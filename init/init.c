#include "printf.h"

void mips_init()
{
	printf("init.c:\tmips_init() is called\n");

	panic("init.c:\tend of mips_init() reached!");
}