#include "lib.h"
#include "fd.h"
#include "mmu.h"
#include "env.h"

extern struct Env *env;
extern uint_64 *vpt;
extern uint_64 *vmd;
extern uint_64 *vud;

static struct Dev *devtab[] =
{
    &devfile,
    &devcons,
    &devpipe,
    0
};

int dev_lookup(int dev_id, struct Dev **dev)
{
    int i;

    for (i = 0; devtab[i]; i++)
        if (devtab[i]->dev_id == dev_id)
        {
            *dev = devtab[i];
            return 0;
        }

    writef("[%08x] unknown device type %d\n", env->env_id, dev_id);
    return -E_INVAL;
}

int fd_alloc(struct Fd **fd)
{
    // Find the smallest i from 0 to MAXFD-1 that doesn't have
    // its fd page mapped.  Set *fd to the fd page virtual address.
    // (Do not allocate a page.  It is up to the caller to allocate
    // the page.  This means that if someone calls fd_alloc twice
    // in a row without allocating the first page we return, we'll
    // return the same page the second time.)
    // Return 0 on success, or an error code on error.
    uint_64 va;
    uint_64 fdno;


	for (fdno = 0; fdno < MAXFD - 1; fdno++)
	{
		va = INDEX2FD(fdno);
		// writef("fd_alloc: va address is 0x%lx\n",va);

        if ((vud[va / PUDMAP] & PTE_VALID) == 0)
        {
            *fd = (struct Fd *)va;
            return 0;
        }

        if ((vmd[va / (512 * BY2PG)] & PTE_VALID) == 0)
        { // the fd is not used
            *fd = (struct Fd *)va;
            return 0;
        }

        if ((vpt[va / BY2PG] & PTE_VALID) == 0)
        { // the fd is not used
            *fd = (struct Fd *)va;
            return 0;
        }
    }

    return -E_MAX_OPEN;
}

void fd_close(struct Fd *fd)
{
    syscall_mem_unmap(0, (uint_64)fd);
}

int fd_lookup(int fdnum, struct Fd **fd)
{
    // Check that fdnum is in range and mapped.  If not, return -E_INVAL.
    // Set *fd to the fd page virtual address.  Return 0.
    uint_64 va;

    if (fdnum >= MAXFD)
    {
        return -E_INVAL;
    }

    va = INDEX2FD(fdnum);

    if ((vpt[va / BY2PG] & PTE_VALID) != 0)
    { 
        // the fd is used
        *fd = (struct Fd *)va;
        return 0;
    }

    return -E_INVAL;
}

uint_64 fd2data(struct Fd *fd)
{
    return INDEX2DATA(fd2num(fd));
}

int fd2num(struct Fd *fd)
{
    return ((uint_64)fd - FDTABLE) / BY2PG;
}

struct Fd *num2fd(int fd)
{
    return (struct Fd *)(fd * BY2PG + FDTABLE);
}

int close(int fdnum)
{
    int r;
    struct Dev *dev;
    struct Fd *fd;

    if ((r = fd_lookup(fdnum, &fd)) < 0 || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
    {
        return r;
    }
    r = (*dev->dev_close)(fd);
    fd_close(fd);
    return r;
}

void close_all(void)
{
    int i;

    for (i = 0; i < MAXFD; i++)
    {
        close(i);
    }
}

int dup(int oldfdnum, int newfdnum)
{
    int i, r;
    uint_64 ova, nva, pte, pmd;
    struct Fd *oldfd, *newfd;

    if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
    {
        return r;
    }

    close(newfdnum);
    newfd = (struct Fd *)INDEX2FD(newfdnum);
    ova = fd2data(oldfd);
    nva = fd2data(newfd);


	if (vud[PUDX(ova)] & PTE_VALID)
	{
		for (i = 0; i < BY2PG * 4096; i += BY2PG)
		{
			pmd = vmd[(PUDX(ova + i) << 9) | PMDX(ova + i)];
			if (!(pmd & PTE_VALID))
			{
				i += 512 * BY2PG;
			}
			pte = vpt[VPN(ova + i)];

			if (pte & PTE_VALID)
			{
				// should be no error here -- pd is already allocated
				if ((r = syscall_mem_map(0, ova + i, 0, nva + i,
										 (pte & PTE_MASK) | (PTE_VALID))) < 0)
				{
					goto err;
				}
			}
		}
	}

	if ((r = syscall_mem_map(0, (uint_64)oldfd, 0, (uint_64)newfd,
							 (vpt[VPN(oldfd)] & PTE_MASK) | (PTE_VALID))) < 0)
	{
		goto err;
	}
	return newfdnum;

err:
    syscall_mem_unmap(0, (uint_64)newfd);

    for (i = 0; i < BY2PG * 4096; i += BY2PG)
    {
        syscall_mem_unmap(0, nva + i);
    }

    return r;
}

// Overview:
//	Read 'n' bytes from 'fd' at the current seek position into 'buf'.
//
// Post-Condition:
//	Update seek position.
//	Return the number of bytes read successfully.
//		< 0 on error
/*** exercise 5.9 ***/
int read(int fdnum, void *buf, u_int n)
{
    int r;
    struct Dev *dev;
    struct Fd *fd;

    // Similar to 'write' function.
    // Step 1: Get fd and dev.
    if ((r = fd_lookup(fdnum, &fd)) < 0)
        return r;

    // writef("read: fd_dev_id is %d\n",fd->fd_dev_id);
    if ((r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
        return r;

    // Step 2: Check open mode.
    if ((fd->fd_omode & O_ACCMODE) == O_WRONLY)
    {
        writef("[%08x] read %d -- bad mode\n", env->env_id, fdnum);
        return -E_INVAL;
    }

    // Step 3: Read starting from seek position.
    r = (*dev->dev_read)(fd, buf, n, fd->fd_offset);

    // Step 4: Update seek position and set '\0' at the end of buf.
    if (r > 0)
    {
        fd->fd_offset += r;
    }

    ((char *)buf)[r] = '\0';

    return r;
}

int readn(int fdnum, void *buf, u_int n)
{
    int m, tot;

    for (tot = 0; tot < n; tot += m)
    {
        m = read(fdnum, (char *)buf + tot, n - tot);

        if (m < 0)
        {
            return m;
        }

        if (m == 0)
        {
            break;
        }
    }

    return tot;
}

int write(int fdnum, const void *buf, u_int n)
{
    int r;
    struct Dev *dev;
    struct Fd *fd;

    if ((r = fd_lookup(fdnum, &fd)) < 0 || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
    {
        return r;
    }

    if ((fd->fd_omode & O_ACCMODE) == O_RDONLY)
    {
        writef("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
        return -E_INVAL;
    }

    r = (*dev->dev_write)(fd, buf, n, fd->fd_offset);

    if (r > 0)
    {
        fd->fd_offset += r;
    }

    return r;
}

int seek(int fdnum, uint_64 offset)
{
    int r;
    struct Fd *fd;

    if ((r = fd_lookup(fdnum, &fd)) < 0)
    {
        return r;
    }

    fd->fd_offset = offset;
    return 0;
}

int fstat(int fdnum, struct Stat *stat)
{
    int r;
    struct Dev *dev;
    struct Fd *fd;


    if ((r = fd_lookup(fdnum, &fd)) < 0 || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
    {
        return r;
    }

    stat->st_name[0] = 0;
    stat->st_size = 0;
    stat->st_isdir = 0;
    stat->st_dev = dev;
    return (*dev->dev_stat)(fd, stat);
}

int stat(const char *path, struct Stat *stat)
{
    int fd, r;

    if ((fd = open(path, O_RDONLY)) < 0)
    {
        return fd;
    }

    r = fstat(fd, stat);

    close(fd);
    
    return r;
}
