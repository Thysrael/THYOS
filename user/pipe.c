#include "lib.h"
#include <mmu.h>
#include <env.h>
#include <fs.h>
#include "fd.h"

static int pipeclose(struct Fd *);
static int piperead(struct Fd *fd, void *buf, u_int n, u_int offset);
static int pipestat(struct Fd *, struct Stat *);
static int pipewrite(struct Fd *fd, const void *buf, u_int n, u_int offset);

extern struct Env *env;
extern struct Env *envs;
extern uint_64 *vpt;
extern uint_64 *vmd;
extern uint_64 *vud;

struct Dev devpipe =
    {
        .dev_id = 'p',
        .dev_name = "pipe",
        .dev_read = piperead,
        .dev_write = pipewrite,
        .dev_close = pipeclose,
        .dev_stat = pipestat,
};

#define BY2PIPE 128 // small to provoke races

struct Pipe
{
    u_int p_rpos;          // read position
    u_int p_wpos;          // write position
    u_char p_buf[BY2PIPE]; // data buffer
};

int pipe(int pfd[2])
{
    int r;
    uint_64 va;
    struct Fd *fd0, *fd1;

    // allocate the file descriptor table entries
    if ((r = fd_alloc(&fd0)) < 0 || (r = syscall_mem_alloc(0, (uint_64)fd0, PTE_VALID | PTE_LIBRARY)) < 0)
        goto err;

    if ((r = fd_alloc(&fd1)) < 0 || (r = syscall_mem_alloc(0, (uint_64)fd1, PTE_VALID | PTE_LIBRARY)) < 0)
        goto err1;

    // allocate the pipe structure as first data page in both
    va = fd2data(fd0);
    if ((r = syscall_mem_alloc(0, va, PTE_VALID | PTE_LIBRARY)) < 0)
        goto err2;
    if ((r = syscall_mem_map(0, va, 0, fd2data(fd1), PTE_VALID | PTE_LIBRARY)) < 0)
        goto err3;
    // print_ref_num(fd2num(fd0));
    // print_ref_num(fd2num(fd1));

    // set up fd structures
    fd0->fd_dev_id = devpipe.dev_id;
    fd0->fd_omode = O_RDONLY;

    fd1->fd_dev_id = devpipe.dev_id;
    fd1->fd_omode = O_WRONLY;


    pfd[0] = fd2num(fd0);
    pfd[1] = fd2num(fd1);
    return 0;

err3:
    syscall_mem_unmap(0, va);
err2:
    syscall_mem_unmap(0, (uint_64)fd1);
err1:
    syscall_mem_unmap(0, (uint_64)fd0);
err:
    return r;
}

static int _pipeisclosed(struct Fd *fd, struct Pipe *p)
{
    // Your code here.
    //
    // Check pageref(fd) and pageref(p),
    // returning 1 if they're the same, 0 otherwise.
    //
    // The logic here is that pageref(p) is the total
    // number of readers *and* writers, whereas pageref(fd)
    // is the number of file descriptors like fd (readers if fd is
    // a reader, writers if fd is a writer).
    //
    // If the number of file descriptors like fd is equal
    // to the total number of readers and writers, then
    // everybody left is what fd is.  So the other end of
    // the pipe is closed.
    int pfd, pfp, runs;
    do
    {
        runs = env->env_runs;
        pfd = pageref(fd);
        pfp = pageref(p);
    } while (runs != env->env_runs);
    //writef("ref: %d %d %d\n", pfd, pfp,pfp - pfd);

    if (pfp == pfd)
    {
        //writef("ref: %d %d %d\n", pfd, pfp, pfp - pfd);
        return 1;
    }

    //	user_panic("_pipeisclosed not implemented");
    return 0;
}

int pipeisclosed(int fdnum)
{
    struct Fd *fd;
    struct Pipe *p;
    int r;

    if ((r = fd_lookup(fdnum, &fd)) < 0)
        return r;
    // writef("fd: %lx\n", fd);
    p = (struct Pipe *)fd2data(fd);
    // writef("fd: %lx %lx\n", fd, p);
    return _pipeisclosed(fd, p);
}

static int piperead(struct Fd *fd, void *vbuf, u_int n, u_int offset)
{
    // Your code here.  See the lab text for a description of
    // what piperead needs to do.  Write a loop that
    // transfers one byte at a time.  If you decide you need
    // to yield (because the pipe is empty), only yield if
    // you have not yet copied any bytes.  (If you have copied
    // some bytes, return what you have instead of yielding.)
    // If the pipe is empty and closed and you didn't copy any data out, return 0.
    // Use _pipeisclosed to check whether the pipe is closed.
    int i;
    struct Pipe *p;
    char *rbuf;

    p = (struct Pipe *)fd2data(fd);
    rbuf = (char *)vbuf;
    for (i = 0; i < n; ++i)
    {
        while (p->p_rpos == p->p_wpos)
        {
            if (_pipeisclosed(fd, p) || i > 0)
                return i;
            syscall_yield();
        }
        rbuf[i] = p->p_buf[p->p_rpos % BY2PIPE];
        p->p_rpos++;
    }
    return n;
    //	user_panic("piperead not implemented");
    //	return -E_INVAL;
}

static int pipewrite(struct Fd *fd, const void *vbuf, u_int n, u_int offset)
{
    // Your code here.  See the lab text for a description of what
    // pipewrite needs to do.  Write a loop that transfers one byte
    // at a time.  Unlike in read, it is not okay to write only some
    // of the data.  If the pipe fills and you've only copied some of
    // the data, wait for the pipe to empty and then keep copying.
    // If the pipe is full and closed, return 0.
    // Use _pipeisclosed to check whether the pipe is closed.
    int i;
    struct Pipe *p;
    char *wbuf;

    p = (struct Pipe *)fd2data(fd);
    wbuf = (char *)vbuf;
    // writef("1\n");
    for (i = 0; i < n; ++i)
    {
        // writef("2\n");
        while (p->p_wpos - p->p_rpos == BY2PIPE)
        {
            // writef("6\n");
            if (_pipeisclosed(fd, p))
                return 0;
            // writef("4\n");
            syscall_yield();
            // writef("5\n");
        }
        p->p_buf[p->p_wpos % BY2PIPE] = wbuf[i];
        p->p_wpos++;
    }
    // writef("3\n");

    //	return -E_INVAL;
    //	user_panic("pipewrite not implemented");

    return n;
    //	return -E_INVAL;

    //	user_panic("pipewrite not implemented");

    //	return n;
}

static int pipestat(struct Fd *fd, struct Stat *stat)
{
    return 0;
}

#include "pmap.h"
static int pipeclose(struct Fd *fd)
{
    syscall_mem_unmap(0, (uint_64)fd);
    syscall_mem_unmap(0, fd2data(fd));
    return 0;
}
