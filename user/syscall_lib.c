#include "lib.h"
#include "sysid.h"

extern uint_64 msyscall(uint_64, uint_64, uint_64, uint_64, uint_64, uint_64);

int syscall_putchar(char ch)
{
    return msyscall(SYS_putchar, (uint_64)ch, 0, 0, 0, 0);
}

uint_32 syscall_getenvid(void)
{
    return msyscall(SYS_getenvid, 0, 0, 0, 0, 0);
}

void syscall_yield(void)
{
    msyscall(SYS_yield, 0, 0, 0, 0, 0);
}

void syscall_env_destroy(uint_32 envid)
{
    msyscall(SYS_env_destroy, (uint_64)envid, 0, 0, 0, 0);
}

int syscall_set_pgfault_handler(uint_32 envid, uint_64 func, uint_64 xstacktop)
{
    return msyscall(SYS_set_pgfault_handler, (uint_64)envid, func, xstacktop, 0, 0);
}

int syscall_mem_alloc(uint_32 envid, uint_64 va, uint_64 perm)
{
    return msyscall(SYS_mem_alloc, (uint_64)envid, va, perm, 0, 0);
}

int syscall_mem_map(uint_32 srcid, uint_64 srcva, uint_32 dstid, uint_64 dstva, uint_64 perm)
{
    return msyscall(SYS_mem_map, (uint_64)srcid, srcva, (uint_64)dstid, dstva, perm);
}

int syscall_mem_unmap(uint_32 envid, uint_64 va)
{
    return msyscall(SYS_mem_unmap, (uint_64)envid, va, 0, 0, 0);
}

int syscall_set_env_status(uint_32 envid, uint_32 status)
{
    return msyscall(SYS_set_env_status, (uint_64)envid, (uint_64)status, 0, 0, 0);
}

int syscall_set_trapframe(uint_32 envid, struct Trapframe *tf)
{
    return msyscall(SYS_set_trapframe, (uint_64)envid, (uint_64)tf, 0, 0, 0);
}

void syscall_panic(char *msg)
{
    msyscall(SYS_panic, (uint_64)msg, 0, 0, 0, 0);
    return;
}

int syscall_ipc_can_send(uint_32 envid, uint_32 value, uint_64 srcva, uint_64 perm)
{
    return msyscall(SYS_ipc_can_send, (uint_64)envid, (uint_64)value, srcva, (uint_64)perm, 0);
}

void syscall_ipc_recv(uint_64 dstva)
{
    msyscall(SYS_ipc_recv, dstva, 0, 0, 0, 0);
}

int syscall_cgetc()
{
    return msyscall(SYS_cgetc, 0, 0, 0, 0, 0);
}
