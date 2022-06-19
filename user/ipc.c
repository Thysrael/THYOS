/*

这个文件夹下是两个 ipc 函数。

参数的类型摆烂了，实在是不想思考类型转换的事情了。

*/


#include "lib.h"
#include "mmu.h"
#include "env.h"

extern struct Env *env;

void ipc_send(uint_32 whom, uint_32 val, uint_64 srcva, uint_64 perm)
{
    int r;

    while ((r = syscall_ipc_can_send(whom, val, srcva, perm)) == -E_IPC_NOT_RECV)
    {
        syscall_yield();
    }

    if (r == 0)
    {
        return;
    }

    user_panic("error in ipc_send: %d", r);
}

uint_32 ipc_recv(uint_32 *whom, uint_64 dstva, uint_64 *perm)
{
    syscall_ipc_recv(dstva);

    if (whom)
    {
        *whom = env->env_ipc_from;
    }

    if (perm)
    {
        *perm = env->env_ipc_perm;
    }

    return env->env_ipc_value;
}