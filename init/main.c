#include "printf.h"
#include "init.h"
#include "uart.h"

int main()
{
    uart_init();
    uart_puts("Hello World!\n");

    printf("main.c:\tmain is start ...\n");

	mips_init();

	panic("main is over is error!");

    return 0;
}