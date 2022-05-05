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
	mips_init();

	panic("main is over is error!");

    return 0;
}