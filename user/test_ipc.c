#include "lib.h"

#define LETTER 0x60000000

void umain(void)
{
    // 测试页面的传递
    u_int who;

    uint_64 *letter = (uint_64 *)LETTER;
    syscall_mem_alloc(0, LETTER, 0);

    if ((who = fork()) != 0)
    {
        // get the ball rolling
        letter[0] = 9527;
        writef("\n0x%lx send %d to 0x%lx\n", syscall_getenvid(), letter[0], who);
        ipc_send(who, 0, LETTER, 0);
    }

    for (;;)
    {
        writef("0x%lx is waiting.....\n", syscall_getenvid());
        ipc_recv(&who, LETTER, 0);

        writef("0x%lx got %d from 0x%lx\n", syscall_getenvid(), letter[0], who);

        if (letter[0] == 9537)
        {
            return;
        }

        letter[0]++;
        writef("\n0x%lx send %d to 0x%lx\n", syscall_getenvid(), letter[0], who);
        ipc_send(who, 0, LETTER, 0);

        if (letter[0] == 9537)
        {
            return;
        }
    }

    // 测试 value 的传递
    // u_int who, i = 0;

    // if ((who = fork()) != 0)
    // {
    //     // get the ball rolling
    //     writef("\n0x%lx send %d to 0x%lx\n", syscall_getenvid(), i, who);
    //     ipc_send(who, 0, 0, 0);
    // }

    // for (;;)
    // {
    //     writef("%x am waiting.....\n", syscall_getenvid());
    //     i = ipc_recv(&who, 0, 0);

    //     writef("%x got %d from %x\n", syscall_getenvid(), i, who);

    //     if (i == 10)
    //     {
    //         return;
    //     }

    //     i++;
    //     writef("\n0x%lx send %d to 0x%lx\n", syscall_getenvid(), i, who);
    //     ipc_send(who, i, 0, 0);

    //     if (i == 10)
    //     {
    //         return;
    //     }
    // }
}
