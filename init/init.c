#include "printf.h"
#include "pmap.h"

void mips_init()
{
	printf("mips_init() is called\n");

    mips_detect_memory();
    arch_basic_init();

    panic("end of mips_init() reached!");
}