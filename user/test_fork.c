#include "lib.h"

void umain()
{
    int a = 0;
    int id = 0;

    if ((id = fork()) == 0)
    {
        if ((id = fork()) == 0)
        {
            a += 3;

            for (;;)
            {
                writef("\t\tthis is child2 :a:%d\n", a);
                writef("\t\tenv xstack is %lx\n", vpt[PPN(UXSTACKTOP)] & (PTE_RO | PTE_COW));
                exit();
            }
        }

        a += 2;

        for (;;)
        {
            writef("\tthis is child :a:%d\n", a);
            writef("\tenv xstack is %lx\n", vpt[PPN(UXSTACKTOP)] & (PTE_RO | PTE_COW));
            exit();
        }
    }

    a++;
    if ((id = fork()) == 0)
    {
        a += 4;

        for (;;)
        {
            writef("\t\tthis is child3 :a:%d\n", a);
            exit();
        }
    }
    for (;;)
    {
        writef("this is father: a:%d\n", a);
        writef("env xstack is %lx\n", vpt[PPN(USTACKTOP)] & (PTE_RO | PTE_COW));
        exit();
    }
    // if (fork() == 0)
    // {
    //     writef("this is child.\n");
    // }
    // else
    // {
    //     writef("this is father.\n");
    // }
}
