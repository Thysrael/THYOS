#include "printf.h"
#include "init.h"
#include "uart.h"

int main()
{
    uart_init();
    printf("start is over.\n");
    printf("Current exception level switched to: %d \r\n", get_EL());

    printf("main is start ...\n");

	mips_init();

	panic("main is over is error!");

    return 0;
}