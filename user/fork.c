/*

这个文件中都是与 fork 相关的函数，合并了原 MOS 中的 pgfault.c 的函数。

__pgfault_handler 函数指针也是在这里声明的。

*/

#include "lib.h"
#include "mmu.h"
#include "env.h"

extern uint_64 *vpt;
extern uint_64 *vmd;
extern uint_64 *vud;
extern struct Env *envs;
extern struct Env *env;

static void pgfault(uint_64 va, struct Trapframe *tf)
{
    // writef("pgfault elr is 0x%lx\n", tf->elr);
    // writef("normal sp is 0x%lx\n", tf->sp);
    uint_64 tmp = USTACKTOP;

    uint_64 perm = vpt[VPN(va)] & 0xfff;
    // writef("user pgfault begin, va is 0x%lx, perm is 0x%lx\n", va, perm);
    if ((perm & PTE_RO) == 0)
    {
        user_panic("pgfault err: COW not found");
    }
    perm -= PTE_RO;
    // map the new page at a temporary place
    syscall_mem_alloc(0, tmp, perm);
    // copy the content
    user_bcopy((const void *)ROUNDDOWN(va, BY2PG), (void *)tmp, BY2PG);
    // map the page on the appropriate place
    syscall_mem_map(0, tmp, 0, va, perm);
    // unmap the temporary place
    syscall_mem_unmap(0, tmp);
}



// 我找不到 library 属性，就去掉了，这可能会造成原有的共享页面达不到效果
static void duppage(u_int envid, uint_64 pn)
{
    // addr is the va we need to process
    uint_64 addr = pn << PTE_SHIFT;
    // *vpt + pn is the adress of page_table_entry which is corresponded to the va
    uint_64 perm = vpt[pn] & 0xfff;
    // if the page can be write and is not shared, so the page need to be COW and map twice
    // writef("duppage addr is 0x%lx\n", addr);
    int flag = 0;
    if ((perm & PTE_RO) == 0)
    {
        perm |= PTE_RO;
        flag = 1;
    }
    syscall_mem_map(0, addr, envid, addr, perm);
    if (flag)
    {
        syscall_mem_map(0, addr, 0, addr, perm);
    }
    // uint_64 tmp = USTACKTOP;
    // syscall_mem_alloc(0, tmp, perm);
    // user_bcopy((void *)ROUNDDOWN(addr, BY2PG), (void *)tmp, BY2PG);
    // syscall_mem_alloc(envid, addr, perm);
    // syscall_mem_map(0, tmp, envid, addr, perm);
    // syscall_mem_unmap(0, tmp);
}

extern void __asm_pgfault_handler(void);
void (*__pgfault_handler)(uint_64, struct Trapframe*);

int fork(void)
{
    int newenvid;
    uint_64 i, j, k;

    // The parent installs pgfault using set_pgfault_handler
    set_pgfault_handler(pgfault);

    // alloc a new alloc
    newenvid = msyscall(SYS_env_alloc, 0, 0, 0, 0, 0);

    if (newenvid == 0)
    {
        env = envs + ENVX(syscall_getenvid());
        // writef("env id is 0x%lx\n", env->env_id);
        return 0;
    }
    
    // for (i = 0; i < VPN(USTACKTOP); i++)
    // {
    //     if ((vud[i >> 18] & PTE_VALID) && (vmd[i >> 9] & PTE_VALID) && (vpt[i] & PTE_VALID))
    //     {
    //         duppage(newenvid, i);
    //     }
    // }

    for (i = 0; i <= PUDX(USTACKTOP); i++)
    {
        if ((vud[i] & PTE_VALID) == 0)
        {
            continue;
        }
        
        for (j = 0; j < 512; j++)
        {
            if ((vmd[(i << 9) + j] & PTE_VALID) == 0)
            {
                continue;
            }
            for (k = 0; k < 512; k++)
            {
                if ((vpt[(i << 18) + (j << 9) + k] & PTE_VALID) == 0 || (i << 18) + (j << 9) + k >= USTACKTOP)
                {
                    continue;
                }
                duppage(newenvid, (i << 18) + (j << 9) + k);
            }
        }
    }

    syscall_mem_alloc(newenvid, UXSTACKTOP - BY2PG, PTE_VALID | PTE_AF | PTE_USER | PTE_ISH | PTE_NORMAL | PTE_RW);
    syscall_set_pgfault_handler(newenvid, (uint_64)__asm_pgfault_handler, UXSTACKTOP);
    syscall_set_env_status(newenvid, ENV_RUNNABLE);
    return newenvid;
}

void set_pgfault_handler(void (*fn)(uint_64 va, struct Trapframe *))
{
    if (__pgfault_handler == 0)
    {
        // map one page of exception stack with top at UXSTACKTOP
        // register assembly handler and stack with operating system
        if (syscall_mem_alloc(0, UXSTACKTOP - BY2PG, PTE_VALID | PTE_AF | PTE_USER | PTE_ISH | PTE_NORMAL | PTE_RW) < 0 ||
            syscall_set_pgfault_handler(0, (uint_64)__asm_pgfault_handler, UXSTACKTOP) < 0)
        {
            writef("cannot set pgfault handler\n");
            return;
        }
    }

    // Save handler pointer for assembly to call.
    __pgfault_handler = fn;
}