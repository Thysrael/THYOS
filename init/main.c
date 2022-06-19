/*

这个函数主要实现了一个包装初始化函数，在这里面只进行了串口的初始化工作。

其他的初始化工作均在 init.c 中进行。

*/


#include "printf.h"
#include "init.h"
#include "uart.h"
#include "tool.h"

extern unsigned long freemem;
extern char _end[];
int main()
{
    uart_init();
    printf("start is over.\n");
    print_exception_level();
    printf("main is start ...\n");
    print_stack();
	arm_init();

	panic("main is over is error!");

    return 0;
}