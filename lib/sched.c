/*

这个文件中主要实现了原有的进程调度函数，此外还实现了一个 handler_irq。

之所以需要用 C 语言实现，是因为 arm 计时器每次中断后都需要重新设置。

*/

#include "sched.h"
#include "env.h"
#include "printf.h"

extern void reset_timer();

void handle_irq(void)
{
    printf("Timer interrupt received\n");
    reset_timer();
    sched_yield();
}

void sched_yield(void)
{
    static int count = 0;           // remaining time slices of current env
    static int point = 0;           // current env_sched_list index
    static struct Env *e = NULL;

    if (count == 0 || e == NULL || e->env_status != ENV_RUNNABLE)
    {
        if (e != NULL)
        {
            LIST_REMOVE(e, env_sched_link);
            if (e->env_status != ENV_FREE)
            {
                LIST_INSERT_TAIL(&env_sched_list[1 - point], e, env_sched_link);
            }
        }
        while (1)
        {
            while (LIST_EMPTY(&env_sched_list[point]))
                point = 1 - point;
            e = LIST_FIRST(&env_sched_list[point]);
            if (e->env_status == ENV_FREE)
                LIST_REMOVE(e, env_sched_link);
            else if (e->env_status == ENV_NOT_RUNNABLE)
            {
                LIST_REMOVE(e, env_sched_link);
                LIST_INSERT_TAIL(&env_sched_list[1 - point], e, env_sched_link);
            }
            else
            {
                count = e->env_pri;
                break;
            }
        }
    }
    count--;
    e->env_runs++;
    env_run(e);
}