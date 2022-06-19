/*

这个文件中实现处理同步异常的分发函数 handle_sync, 还有缺页异常的处理函数。

同步异常主要是三种，系统调用，页表缺失，页表权限错误（即 cow ）。

在系统调用的时候，需要进行类型转换，因为通用寄存器都是 64 位的。

cow 的实现方式就是检测是否写了只读页面。

*/

#include "sync.h"
#include "types.h"
#include "trap.h"
#include "printf.h"
#include "mmu.h"
#include "unistd.h"
#include "syscall.h"
#include "tool.h"
#include "env.h"
#include "pmap.h"

void handle_sync(struct Trapframe *tf, uint_64 *ttbr0, uint_64 *ttbr1)
{
    printf("Handling the sync.\n");
    uint_64 far = tf->far;
    uint_64 esr = tf->esr;
    uint_64 EC = esr >> 26;
    printf("far is 0x%lx.\n", far);
    printf("esr is 0x%lx.\n", esr);
    printf("EC is 0x%lx.\n", EC);
    panic("stop");
    // 异常是系统调用
    if ((esr >> 26) == 0b010101)
    {
        uint_64 syscall_id = tf->x[0];
        // 这里保存一个系统调用的值, x0 承担了第一个参数和返回值两个任务
        int r = 0;
        switch (syscall_id)
        {
        SYS_putchar:
            sys_putchar(tf->x[1]);
            break;
        SYS_getenvid:
            r = sys_getenvid();
            break;
        SYS_yield:
            sys_yield();
            break;
        SYS_env_destroy:
            r = sys_env_destroy((u_int)tf->x[1]);
            break;
        SYS_set_pgfault_handler:
            r = sys_set_pgfault_handler((u_int)tf->x[1], tf->x[2], tf->x[3]);
            break;
        SYS_mem_alloc:
            r = sys_mem_alloc((u_int)tf->x[1], tf->x[2], (u_int)tf->x[3]);
            break;
        SYS_mem_map:
            r = sys_mem_map((u_int)tf->x[1], tf->x[2], (u_int)tf->x[3], tf->x[4], (u_int)tf->x[5]);
            break;
        SYS_mem_unmap:
            r = sys_mem_unmap((u_int)tf->x[1], tf->x[2]);
            break;
        SYS_env_alloc:
            r = sys_env_alloc();
            break;
        SYS_set_env_status:
            r = sys_set_env_status((u_int)tf->x[1], (u_int)tf->x[2]);
            break;
        SYS_set_trapframe:
            r = sys_set_trapframe((u_int)tf->x[1], (struct Trapframe *)tf->x[2]);
            break;
        SYS_panic:
            sys_panic((char *)tf->x[1]);
            break;
        SYS_ipc_recv:
            sys_ipc_recv(tf->x[1]);
            break;
        SYS_ipc_can_send:
            r = sys_ipc_can_send(tf->x[1], (u_int)tf->x[2], tf->x[3], (u_int)tf->x[4]);
            break;
        SYS_write_dev:
            r = sys_write_dev(tf->x[1], tf->x[2], (u_int)tf->x[3]);
            break;
        SYS_read_dev:
            r = sys_read_dev(tf->x[1], tf->x[2], (u_int)tf->x[3]);
            break;
        SYS_cgetc:
        default:
            printf("Unknown syscall id %d.\n", syscall_id);
            break;
        }
        // 将返回值修改
        tf->x[0] = (long)r;
    }
    else if ((esr >> 26) == 0x20 || (esr >> 26) == 0x21)
    {
        uint_64 DFSC = esr & 0x3f;
        // 异常是页表缺失
        if (DFSC >= 4 && DFSC <= 7)
        {
            if (far > KERNEL_BASE)
            {
                pageout(far, ttbr1);
            }
            else
            {
                pageout(far, ttbr0);
            }
        }
        // 异常是 cow
        else if (DFSC >= 13 && DFSC <= 15)
        {
            page_fault_handler(tf);
        }
        else
        {
            printf("Unknown data sync.\n");
        }
    }
}

void page_fault_handler(struct Trapframe *tf)
{
    struct Trapframe PgTrapFrame;
    extern struct Env *curenv;

    bcopy(tf, &PgTrapFrame, sizeof(struct Trapframe));

    if (tf->sp >= (curenv->env_xstacktop - BY2PG) &&
        tf->sp <= (curenv->env_xstacktop - 1))
    {
        tf->sp = tf->sp - sizeof(struct Trapframe);
        bcopy(&PgTrapFrame, (void *)tf->sp, sizeof(struct Trapframe));
    }
    else
    {
        tf->sp = curenv->env_xstacktop - sizeof(struct Trapframe);
        bcopy(&PgTrapFrame, (void *)curenv->env_xstacktop - sizeof(struct Trapframe), sizeof(struct Trapframe));
    }
    // Set EPC to a proper value in the trapframe
    tf->elr = curenv->env_pgfault_handler;

    return;
}