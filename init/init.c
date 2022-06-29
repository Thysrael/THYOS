/*

在这个文件中完成了操作系统初始化的工作。

*/


#include "printf.h"
#include "pmap.h"
#include "env.h"
#include "tool.h"

extern void reset_timer();
extern void irq_vector_init();

void arm_init()
{
	printf("arm_init() is called\n");

    // 初始化物理地址
    mips_detect_memory();
    // 初始化虚拟地址
    arch_basic_init();
    sd_init();
    // 初始化进程管理
    env_init();
    ENV_CREATE(fs_serv);
    //ENV_CREATE(user_fstest);
    ENV_CREATE(user_testpiperace);
    //ENV_CREATE(user_testpipe);
    //ENV_CREATE(user_test_fork);
    // 初始化进程
    //ENV_CREATE(user_test_ipc);
    // ENV_CREATE(test_sys);
    // 初始化异常向量表
    irq_vector_init();
    printf("Irq vector has inited successfully.\n");
    // 开始树莓派中断
    enable_interrupt_controller();
    printf("Interupt controller has enabled.\n");
    // 开启计时器
    reset_timer();
    printf("Timer start.\n");

    while(1);
    panic("end of arm_init() reached!");
}