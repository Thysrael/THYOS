#ifndef _LIB_H_
#define _LIB_H_

#include "types.h"
#include "trap.h"
#include "sysid.h"
#include "fd.h"
#include <stdarg.h>
#include "env.h"
#include "args.h"

extern struct Env *env;
extern struct Env *envs;
extern uint_64 *vpt;
extern uint_64 *vmd;
extern uint_64 *vud;

#define USED(x) (void)(x)

#define DEBUG 0

//------------------ console.c -----------------//

int iscons(int fdnum);

int opencons(void);

int cons_read(struct Fd *fd, void *vbuf, u_int n, u_int offset);

int cons_write(struct Fd *fd, const void *vbuf, u_int n, u_int offset);

int cons_close(struct Fd *fd);

int cons_stat(struct Fd *fd, struct Stat *stat);

//-------------------- fd.c -------------------//

int close(int fd);

int read(int fd, void *buf, u_int nbytes);

int write(int fd, const void *buf, u_int nbytes);

int seek(int fd, uint_64 offset);

void close_all(void);

int readn(int fd, void *buf, u_int nbytes);

int dup(int oldfd, int newfd);

int fstat(int fdnum, struct Stat *stat);

int stat(const char *path, struct Stat *);

//------------------- file.c ------------------//

int open(const char *path, int mode);

int read_map(int fd, uint_64 offset, void **blk);

int remove(const char *path);

int ftruncate(int fd, u_int size);

int sync(void);

//------------------ fork.c ------------------//

int fork(void);

void set_pgfault_handler(void (*fn)(uint_64 va, struct Trapframe *));

int fsipc_set_size(u_int fileid, u_int size);

int fsipc_close(u_int fileid);

int fsipc_dirty(u_int fileid, u_int offset);

int fsipc_remove(const char *path);

int fsipc_sync(void);

//------------------ fsipc.c ------------------//

int fsipc_open(const char *path, u_int omode, struct Fd *fd);

int fsipc_map(u_int fileid, u_int offset, uint_64 dstva);

//----------------- fprintf.c -----------------//

int fwritef(int fd, const char *fmt, ...);

//------------------ ipc.c -------------------//

void ipc_send(uint_32 whom, uint_32 val, uint_64 srcva, uint_64 perm);

uint_32 ipc_recv(uint_32 *whom, uint_64 dstva, uint_64 *perm);

//------------------ libso.c -----------------//

void exit(void);

void user_bcopy(const void *src, void *dst, uint_64 len);

void user_bzero(void *v, u_int n);

u_short pageref(void *v);

void wait(u_int envid);

void libmain(int argc, char **argv);

//------------------ pipe.c -----------------//

int pipe(int pfd[2]);

int pipeisclosed(int fdnum);

//------------------ printf.c -----------------//

void writef(char *fmt, ...);
void debug_printf(char *src, int line, char *fmt, ...);

#define debug(...) debug_printf(__FILE__, __LINE__, __VA_ARGS__)

void _user_panic(const char *file, int line, const char *fmt, ...);

void _user_panic(const char *, int, const char *, ...)
    __attribute__((noreturn));

#define user_panic(...) _user_panic(__FILE__, __LINE__, __VA_ARGS__)

#define user_assert(x)                              \
    do                                              \
    {                                               \
        if (!(x))                                   \
            user_panic("assertion failed: %s", #x); \
    } while (0)

//------------------ print.c ------------------//

#define LP_MAX_BUF 1000
void user_lp_Print(void (*output)(void *, const char *, int),
                   void *arg,
                   const char *fmt,
                   va_list ap);

//------------------ spawn.c ------------------//

int spawnl(char *prog, ...);

int spawn(char *prog, char **argv);

//------------------ string.c ------------------//

int strlen(const char *s);

char *strcpy(char *dst, const char *src);

const char *strchr(const char *s, char c);

void *memcpy(void *destaddr, void const *srcaddr, u_int len);

int strcmp(const char *p, const char *q);

//---------------- syscall_lib.c ---------------//

extern uint_64 msyscall(uint_64, uint_64, uint_64, uint_64, uint_64, uint_64);

int syscall_putchar(char ch);

uint_32 syscall_getenvid(void);

void syscall_yield(void);

void syscall_env_destroy(uint_32 envid);

int syscall_set_pgfault_handler(uint_32 envid, uint_64 func, uint_64 xstacktop);

int syscall_mem_alloc(uint_32 envid, uint_64 va, uint_64 perm);

int syscall_mem_map(uint_32 srcid, uint_64 srcva, uint_32 dstid, uint_64 dstva, uint_64 perm);

int syscall_mem_unmap(uint_32 envid, uint_64 va);

int syscall_set_env_status(uint_32 envid, uint_32 status);

int syscall_set_trapframe(uint_32 envid, struct Trapframe *tf);

void syscall_panic(char *msg);

int syscall_ipc_can_send(uint_32 envid, uint_32 value, uint_64 srcva, uint_64 perm);

void syscall_ipc_recv(uint_64 dstva);

int syscall_cgetc();

int syscall_write_sd(uint_64 blockno, void *data_addr);

int syscall_read_sd(uint_64 blockno, void *data_addr);

void syscall_init_stack(uint_32 envid, uint_64 esp, uint_64 argc_in_reg, uint_64 argv_in_reg);

/* File open modes */
#define O_RDONLY 0x0000  /* open for reading only */
#define O_WRONLY 0x0001  /* open for writing only */
#define O_RDWR 0x0002    /* open for reading and writing */
#define O_ACCMODE 0x0003 /* mask for above modes */

#define O_CREAT 0x0100 /* create if nonexistent */
#define O_TRUNC 0x0200 /* truncate to zero length */
#define O_EXCL 0x0400  /* error if already exists */
#define O_MKDIR 0x0800 /* create directory, not regular file */

#endif