#include "tool.h"
#include "printf.h"

void alouha()
{
    printf("alouha... \n");
}

void print_stack()
{
    int tmp;
    printf("Kernel stack base at 0x%lx .\n", &tmp);
}

void print_exception_level()
{
    printf("Current exception level switched to Level %d .\n", get_EL());
}

