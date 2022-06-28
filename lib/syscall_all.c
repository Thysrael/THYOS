/*

这个文件里所有系统调用函数的具体实现。

因为使用了 C 语言，所以对于传参的灵活性增加，不再需要固定的传参格式。


*/

#include "types.h"
#include "printf.h"
#include "uart.h"
#include "env.h"
#include "tool.h"
#include "pmap.h"
#include "sched.h"

extern struct Env *curenv;

// 这里改成了用 uart_send 进行输出
void sys_putchar(uint_64 c)
{
    uart_send((uint_32)c);
    return;
}

u_int sys_getenvid(void)
{
    return curenv->env_id;
}

void sys_yield(void)
{
    struct Trapframe *src = (struct Trapframe *)(KERNEL_SP - sizeof(struct Trapframe));
    struct Trapframe *dst = (struct Trapframe *)(TIMESTACK - sizeof(struct Trapframe));
    bcopy((void *)src, (void *)dst, sizeof(struct Trapframe));
    sched_yield();
}

int sys_env_destroy(uint_32 envid)
{
    int r;
    struct Env *e;

    if ((r = envid2env(envid, &e, 1)) < 0)
    {
        return r;
    }
    
    env_destroy(e);
    return 0;
}

int sys_set_pgfault_handler(u_int envid, uint_64 func, uint_64 xstacktop)
{
    struct Env *env;
    int ret;

    // get the env
    ret = envid2env(envid, &env, 0);
    if (ret)
    {
        return ret;
    }

    // set the env_pgfault_handler as the set_pgfault_handler
    env->env_pgfault_handler = func;
    env->env_xstacktop = xstacktop;
    return 0;
}

int sys_mem_alloc(u_int envid, uint_64 va, uint_64 perm)
{
    struct Env *env;
    struct Page *ppage;
    int ret;
    ret = 0;
    // check whether permission is legal
    if (!(perm & PTE_VALID))
    {
        printf("sys_mem_alloc:permission denined\n");
        return -E_INVAL;
    }

    // try to alloc a page
    ret = page_alloc(&ppage);
    if (ret < 0)
    {
        printf("sys_mem_alloc:failed to alloc a page\n");
        return -E_NO_MEM;
    }
    // try to check and get the env_id;
    ret = envid2env(envid, &env, 1);
    if (ret < 0)
    {
        printf("sys_mem_alloc:failed to get the target env\n");
        return -E_BAD_ENV;
    }
    // now insert
    ret = page_insert(env->env_pgdir, ppage, va, perm);
    if (ret < 0)
    {
        printf("sys_mem_alloc:page_insert failed");
        return -E_NO_MEM;
    }
    return 0;
}

int sys_mem_map(u_int srcid, uint_64 srcva, u_int dstid, uint_64 dstva, uint_64 perm)
{
    int ret;
    uint_64 round_srcva, round_dstva;
    struct Env *srcenv;
    struct Env *dstenv;
    struct Page *ppage;
    uint_64 *ppte;

    ppage = NULL;
    ret = 0;
    round_srcva = ROUNDDOWN(srcva, BY2PG);
    round_dstva = ROUNDDOWN(dstva, BY2PG);

    //  get corresponding env
    if (envid2env(srcid, &srcenv, 1) < 0)
    {
        printf("sys_mem_map:srcenv doesn't exist\n");
        return -E_BAD_ENV;
    }
    if (envid2env(dstid, &dstenv, 1) < 0)
    {
        printf("sys_mem_map:dstenv doesn't exist\n");
        return -E_BAD_ENV;
    }

    // perm is valid?
    if (!(perm & PTE_VALID))
    {
        printf("sys_mem_map:permission denied, va is 0x%lx\n", round_srcva);
        return -E_NO_MEM;
    }
    // check the va
    if (srcva >= UTOP || dstva >= UTOP)
    {
        printf("sys_mem_map:virtual address exceeds the UTOP\n");
        return -E_INVAL;
    }
    // try to get the page
    ppage = page_lookup(srcenv->env_pgdir, round_srcva, &ppte);
    if (ppage == NULL)
    {
        printf("sys_mem_map:page of srcva is invalid\n");
        return -E_NO_MEM;
    }
    // try to insert the page
    ret = page_insert(dstenv->env_pgdir, ppage, round_dstva, perm);
    if (ret < 0)
    {
        printf("sys_mem_map:page_insert denied\n");
        return -E_NO_MEM;
    }
    return 0;
}

int sys_mem_unmap(u_int envid, uint_64 va)
{
    int ret = 0;
    struct Env *env;

    ret = envid2env(envid, &env, 1); 
    if (ret < 0)
    {
        printf("sys_mem_alloc:failed to get the target env\n");
        return -E_BAD_ENV;
    }
    page_remove(env->env_pgdir, va);
    return ret;
}

int sys_env_alloc(void)
{
    int r;
    struct Env *e;

    // alloc a new env
    r = env_alloc(&e, curenv->env_id);
    if (r < 0)
    {
        return r;
    }
    // set the statur of new env
    e->env_status = ENV_NOT_RUNNABLE;

    // copy the father env to the child env
    e->env_pri = curenv->env_pri;
    bcopy((void *)KERNEL_SP - sizeof(struct Trapframe),
          (void *)(&(e->env_tf)), sizeof(struct Trapframe));

    // set the return value = 0
    e->env_tf.x[0] = 0;
    return e->env_id;
}

int sys_set_env_status(u_int envid, u_int status)
{
    struct Env *env;
    int ret;

    // check the status
    if (status != ENV_RUNNABLE && status != ENV_NOT_RUNNABLE && status != ENV_FREE)
    {
        return -E_INVAL;
    }

    // get the env
    ret = envid2env(envid, &env, 0);
    if (ret)
    {
        return ret;
    }
    if (status == ENV_RUNNABLE && env->env_status != ENV_RUNNABLE)
    {
        LIST_INSERT_TAIL(env_sched_list, env, env_sched_link);
    }
    env->env_status = status;
    return 0;
}

int sys_set_trapframe(u_int envid, struct Trapframe *tf)
{
    panic("sys_set_trapframe has not be implemented.\n");
    return 0;
}

void sys_panic(char *msg)
{
    panic("%s", msg);
}

void sys_ipc_recv(uint_64 dstva)
{
    // check the va
    if (dstva >= UTOP)
    {
        return;
    }
    // set the status
    curenv->env_ipc_recving = 1;
    // set the dstva
    curenv->env_ipc_dstva = dstva;
    // block the env
    curenv->env_status = ENV_NOT_RUNNABLE;
    // we can't use the env_yield, because of the timer Irq
    sys_yield();
}

int sys_ipc_can_send(uint_64 envid, u_int value, uint_64 srcva, uint_64 perm)
{

    int r;
    struct Env *e;
    struct Page *p;

    // check the srcva
    if (srcva >= UTOP)
    {
        return -E_INVAL;
    }

    // get the dstenv
    r = envid2env(envid, &e, 0);
    if (r < 0)
    {
        return r;
    }
    if (e->env_ipc_recving == 0)
    {
        return -E_IPC_NOT_RECV;
    }
    // pass the value
    e->env_ipc_value = value;
    e->env_ipc_from = curenv->env_id;
    e->env_ipc_perm = perm;
    e->env_ipc_recving = 0;

    if (srcva != 0)
    {
        // share the physical page
        p = page_lookup(curenv->env_pgdir, srcva, NULL);
        if (p == NULL || e->env_ipc_dstva >= UTOP)
        {
            return -E_INVAL;
        }
        r = page_insert(e->env_pgdir, p, e->env_ipc_dstva, perm);
        if (r != 0)
        {
            return r;
        }
    }

    e->env_status = ENV_RUNNABLE;
    return 0;
}

int sys_write_dev(uint_64 va, uint_64 dev, u_int len)
{
    panic("sys_write_dev has not be implemented.\n");
    return 0;
}

int sys_read_dev(uint_64 va, uint_64 dev, u_int len)
{
    panic("sys_read_dev has not be implemented.\n");
    return 0;
}