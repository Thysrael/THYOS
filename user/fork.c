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


static void pgfault(uint_64 va)
{
    uint_64 tmp = USTACKTOP;

    uint_64 perm = vpt[VPN(va)] & 0xfff;
    if ((perm & PTE_RO) == 0)
    {
        user_panic("pgfault err: COW not found");
    }
    perm -= PTE_RO;
    // map the new page at a temporary place
    syscall_mem_alloc(0, tmp, perm);
    // copy the content
    user_bcopy((void *)ROUNDDOWN(va, BY2PG), (void *)tmp, BY2PG);
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
    int flag = 0;
    if (perm & PTE_RW)
    {
        perm |= PTE_RO;
        flag = 1;
    }
    syscall_mem_map(0, addr, envid, addr, perm);
    if (flag)
    {
        syscall_mem_map(0, addr, 0, addr, perm);
    }
}

extern void __asm_pgfault_handler(void);
void (*__pgfault_handler)(uint_64);

int fork(void)
{
    u_int newenvid;
    uint_64 i;

    // The parent installs pgfault using set_pgfault_handler
    set_pgfault_handler(pgfault);

    // alloc a new alloc
    newenvid = syscall_env_alloc();
    if (newenvid == 0)
    {
        env = envs + ENVX(syscall_getenvid());
        return 0;
    }

    for (i = 0; i < VPN(USTACKTOP); i++)
    {
        if ((vud[i >> 18] & PTE_VALID) && (vmd[i >> 9] & PTE_VALID) && (vpt[i] & PTE_VALID))
        {
            duppage(newenvid, i);
        }
    }

    syscall_mem_alloc(newenvid, UXSTACKTOP - BY2PG, PTE_VALID | PTE_AF | PTE_USER | PTE_ISH | PTE_NORMAL | PTE_RW);
    syscall_set_pgfault_handler(newenvid, (uint_64)__asm_pgfault_handler, UXSTACKTOP);
    syscall_set_env_status(newenvid, ENV_RUNNABLE);
    return newenvid;
}

void set_pgfault_handler(void (*fn)(uint_64 va))
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