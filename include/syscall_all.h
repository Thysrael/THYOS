/*

这个文件用于对所有系统调用函数的声明。

在 MOS 中，这些函数的声明是在汇编中完成并构成呢改系统调用表，但是这里采用了 C 的 switch 语句


*/

#ifndef _SYSCALL_H_
#define _SYSCALL_H_

#include "types.h"

void sys_putchar(uint_64 c);
u_int sys_getenvid(void);
void sys_yield(void);
int sys_env_destroy(u_int envid);
int sys_set_pgfault_handler(u_int envid, uint_64 func, uint_64 xstacktop);
int sys_mem_alloc(u_int envid, uint_64 va, uint_64 perm);
int sys_mem_map(u_int srcid, uint_64 srcva, u_int dstid, uint_64 dstva, uint_64 perm);
int sys_mem_unmap(u_int envid, uint_64 va);
int sys_env_alloc(void);
int sys_set_env_status(u_int envid, u_int status);
int sys_set_trapframe(u_int envid, struct Trapframe *tf);
void sys_panic(char *msg);
void sys_ipc_recv(uint_64 dstva);
int sys_ipc_can_send(uint_64 envid, u_int value, uint_64 srcva, uint_64 perm);
int sys_write_sd(uint_64 blockno, void* data_addr);
int sys_read_sd(uint_64 blockno, void* data_addr);
#endif