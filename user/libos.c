/*

这个文件夹里的内容主要是用户 main 的包装函数，同时声明了一些自映射相关的变量，还有一些工具函数。

这些变量不再采用指针的指针的方式。

*/

#include "lib.h"
#include "mmu.h"
#include "env.h"
#include "pmap.h"

struct Env *env;
uint_64 *vpt = (uint_64 *)UVPT;
uint_64 *vmd = (uint_64 *)UVMD;
uint_64 *vud = (uint_64 *)UVUD;
struct Page *pages = (struct Page *)UPAGES;
struct Env *envs = (struct Env *)UENVS;

void exit(void)
{
    syscall_env_destroy(0);
}

void user_bcopy(const void *src, void *dst, uint_64 len)
{
    void *max;

    max = dst + len;

    // copy machine words while possible
    if (((uint_64)src % 8 == 0) && ((uint_64)dst % 8 == 0))
    {
        while (dst + 8 < max)
        {
            *(uint_64 *)dst = *(uint_64 *)src;
            dst += 8;
            src += 8;
        }
    }

    // finish remaining 0-3 bytes
    while (dst < max)
    {
        *(char *)dst = *(char *)src;
        dst += 1;
        src += 1;
    }
}


void user_bzero(void *v, u_int n)
{
    char *p;
    int m;

    p = v;
    m = n;

    while (--m >= 0)
    {
        *p++ = 0;
    }
}

u_short pageref(void *v)
{

    if (!(vud[PUDX(v)] & PTE_VALID))
    {
        return 0;
    }

    uint_64 vmd_entry = vmd[(PUDX(v) << 9) | PMDX(v)];
    if (!(vmd_entry & PTE_VALID))
    {
        return 0;
    }

    uint_64 pte = vpt[(PUDX(v) << 18) | (PMDX(v) << 9) | PTEX(v)];

    if (!(pte & PTE_VALID))
    {
        return 0;
    }

    return pages[PPN(pte)].pp_ref;
}

void wait(u_int envid)
{
    struct Env *e;

    e = &envs[ENVX(envid)];
    while (e->env_id == envid && e->env_status != ENV_FREE)
    {
        syscall_yield();
    }
}

extern void umain(int argc, char **argv);

void libmain(int argc, char **argv)
{
    // set env to point at our env structure in envs[].
    env = 0;
    int envid;
    envid = syscall_getenvid();
    envid = ENVX(envid);
    env = envs + envid;
    
    // call user main routine
    umain(argc, argv);
    // exit gracefully
    exit();
}