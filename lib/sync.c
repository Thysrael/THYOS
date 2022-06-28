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
#include "sysid.h"
#include "syscall_all.h"
#include "tool.h"
#include "env.h"
#include "pmap.h"

void handle_sync(struct Trapframe *tf, uint_64 *ttbr0, uint_64 *ttbr1)
{
    debug("\n");
    debug("Handling the sync.\n");
    uint_64 far = tf->far;
    uint_64 esr = tf->esr;
    uint_64 EC = esr >> 26;
    debug("far is 0x%lx.\n", far);
    debug("esr is 0x%lx.\n", esr);
    debug("EC is 0x%lx.\n", EC);

    // 异常是系统调用
    if ((EC) == 0x15)
    {
        uint_64 syscall_id = tf->x[0];
        debug("Handling the syscall. Syscall id is %ld\n", syscall_id);

        // 这里保存一个系统调用的值, x0 承担了第一个参数和返回值两个任务
        int r = 0;
        switch (syscall_id)
        {
        case SYS_putchar:
            debug("syscall is sys_putchar\n");
            sys_putchar(tf->x[1]);
            break;
        case SYS_getenvid:
            debug("syscall is sys_get_envid\n");
            r = sys_getenvid();
            break;
        case SYS_yield:
            debug("syscall is sys_yield\n");
            sys_yield();
            break;
        case SYS_env_destroy:
            debug("syscall is sys_destroy\n");
            r = sys_env_destroy((u_int)tf->x[1]);
            break;
        case SYS_set_pgfault_handler:
            debug("syscall is sys_set_pgfault_handler\n");
            r = sys_set_pgfault_handler((u_int)tf->x[1], tf->x[2], tf->x[3]);
            break;
        case SYS_mem_alloc:
            debug("syscall is sys_mem_alloc\n");
            r = sys_mem_alloc((u_int)tf->x[1], tf->x[2], (u_int)tf->x[3]);
            break;
        case SYS_mem_map:
            debug("syscall is sys_mem_map\n");
            r = sys_mem_map((u_int)tf->x[1], tf->x[2], (u_int)tf->x[3], tf->x[4], (u_int)tf->x[5]);
            break;
        case SYS_mem_unmap:
            debug("syscall is sys_mem_umap\n");
            r = sys_mem_unmap((u_int)tf->x[1], tf->x[2]);
            break;
        case SYS_env_alloc:
            debug("syscall is sys_env_alloc\n");
            r = sys_env_alloc();
            break;
        case SYS_set_env_status:
            debug("syscall is sys_set_env_status\n");
            r = sys_set_env_status((u_int)tf->x[1], (u_int)tf->x[2]);
            break;
        case SYS_set_trapframe:
            debug("syscall is sys_set_trapframe\n");
            r = sys_set_trapframe((u_int)tf->x[1], (struct Trapframe *)tf->x[2]);
            break;
        case SYS_panic:
            debug("syscall is sys_panic\n");
            sys_panic((char *)tf->x[1]);
            break;
        case SYS_ipc_recv:
            debug("syscall is sys_ipc_recv\n");
            sys_ipc_recv(tf->x[1]);
            break;
        case SYS_ipc_can_send:
            debug("syscall is sys_ipc_can_send\n");
            r = sys_ipc_can_send(tf->x[1], (u_int)tf->x[2], tf->x[3], (u_int)tf->x[4]);
            break;
        case SYS_write_dev:
            debug("syscall is sys_write_dev\n");
            r = sys_write_dev(tf->x[1], tf->x[2], (u_int)tf->x[3]);
            break;
        case SYS_read_dev:
            debug("syscall is sys_read_dev\n");
            r = sys_read_dev(tf->x[1], tf->x[2], (u_int)tf->x[3]);
            break;
        case SYS_cgetc:
        default:
            printf("Unknown syscall id %d.\n", syscall_id);
            break;
        }
        // 将返回值修改
        tf->x[0] = (long)r;
    }
    else if (EC == 0x20 || EC == 0x21 || EC == 0x24 || EC == 0x25)
    {
        uint_64 DFSC = esr & 0x3f;
        debug("DFSC is %ld,\n", DFSC);
        // 异常是页表缺失
        if (DFSC >= 4 && DFSC <= 7)
        {
            debug("Handling the page lost.\n");
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
            debug("Hanlding the copy on write.\n");
            page_fault_handler(tf);
        }
        else
        {
            panic("Unknown data sync.\n");
        }
    }
    else
    {
        panic("Unkown sync\n");
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