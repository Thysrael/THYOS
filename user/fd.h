#ifndef _USER_FD_H_
#define _USER_FD_H_ 

#include "types.h"
#include <fs.h>
#include "mmu.h"

#define MAXFD 512
#define FILEBASE 0x800000000
#define FDTABLE (FILEBASE - (PMDMAP))
#define STDIN_FILENO 0
#define STDOUT_FILENO 1

#define INDEX2FD(i) (FDTABLE + (i) * BY2PG)
#define INDEX2DATA(i) (FILEBASE + (i) * PMDMAP)

// pre-declare for forward references
struct Fd;
struct Stat;
struct Dev;

// Device struct:
// It is used to read and write data from corresponding device.
// We can use the five functions to handle data.
// There are three devices in this OS: file, console and pipe.
struct Dev
{
    int dev_id;
    char *dev_name;
    int (*dev_read)(struct Fd *, void *, u_int, u_int);
    int (*dev_write)(struct Fd *, const void *, u_int, u_int);
    int (*dev_close)(struct Fd *);
    int (*dev_stat)(struct Fd *, struct Stat *);
    int (*dev_seek)(struct Fd *, u_int);
};

extern struct Dev devcons;
extern struct Dev devfile;
extern struct Dev devpipe;

// file descriptor
struct Fd
{
    u_int fd_dev_id;
    uint_64 fd_offset;
    u_int fd_omode;
};

// State
struct Stat
{
    char st_name[MAXNAMELEN];
    uint_64 st_size;
    u_int st_isdir;
    struct Dev *st_dev;
};

// file descriptor + file
struct Filefd
{
    struct Fd f_fd;
    u_int f_fileid;
    struct File f_file;
};

int fd_alloc(struct Fd **fd);
int fd_lookup(int fdnum, struct Fd **fd);
uint_64 fd2data(struct Fd *);
int fd2num(struct Fd *);
int dev_lookup(int dev_id, struct Dev **dev);
struct Fd *num2fd(int fd);

#endif
