#ifndef _LIB_H_
#define _LIB_H_

#include "types.h"
#include "trap.h"
#include <stdarg.h>


//------------------ fork.c ------------------//

int fork(void);

void set_pgfault_handler(void (*fn)(uint_64 va));

//------------------ ipc.c -------------------//

void ipc_send(uint_32 whom, uint_32 val, uint_64 srcva, uint_64 perm);

uint_32 ipc_recv(uint_32 *whom, uint_64 dstva, uint_64 *perm);

//------------------ libso.c -----------------//

void exit(void);

void user_bcopy(const void *src, void *dst, uint_32 len);

void user_bzero(void *v, u_int n);

void libmain(int argc, char **argv);

//------------------ printf.c -----------------//

void writef(char *fmt, ...);

void _user_panic(const char *file, int line, const char *fmt, ...);

void _user_panic(const char *, int, const char *, ...)
    __attribute__((noreturn));

#define user_panic(...) _user_panic(__FILE__, __LINE__, __VA_ARGS__)

//------------------ print.c ------------------//

#define LP_MAX_BUF 1000
void user_lp_Print(void (*output)(void *, const char *, int),
                   void *arg,
                   const char *fmt,
                   va_list ap);

//------------------ string.c ------------------//

int strlen(const char *s);

char *strcpy(char *dst, const char *src);

const char *strchr(const char *s, char c);

void *memcpy(void *destaddr, void const *srcaddr, u_int len);

int strcmp(const char *p, const char *q);

//---------------- syscall_lib.c ---------------//

int syscall_putchar(char ch);

uint_32 syscall_getenvid(void);

void syscall_yield(void);

void syscall_env_destroy(uint_32 envid);

int syscall_set_pgfault_handler(uint_32 envid, uint_64 func, uint_64 xstacktop);

int syscall_mem_alloc(uint_32 envid, uint_64 va, uint_64 perm);

int syscall_mem_map(uint_32 srcid, uint_64 srcva, uint_32 dstid, uint_64 dstva, uint_64 perm);

int syscall_mem_unmap(uint_32 envid, uint_64 va);

int syscall_env_alloc(void);

int syscall_set_env_status(uint_32 envid, uint_32 status);

int syscall_set_trapframe(uint_32 envid, struct Trapframe *tf);

void syscall_panic(char *msg);

int syscall_ipc_can_send(uint_32 envid, uint_32 value, uint_64 srcva, uint_64 perm);

void syscall_ipc_recv(uint_64 dstva);

int syscall_cgetc();

#endif