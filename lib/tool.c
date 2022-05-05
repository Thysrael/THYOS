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

void bcopy(const void *src, void *dst, unsigned long len)
{
    void *max;
    max = dst + len;
    // copy machine words while possible
    while (dst + 3 < max)
    {
        *(int *)dst = *(int *)src;
        dst += 4;
        src += 4;
    }
    // finish remaining 0-3 bytes
    while (dst < max)
    {
        *(char *)dst = *(char *)src;
        dst += 1;
        src += 1;
    }
}

void bzero(void *b, unsigned long len)
{
    void *max;

    max = b + len;
    // zero machine words while possible
    while (b + 3 < max)
    {
        *(int *)b = 0;
        b += 4;
    }
    // finish remaining 0-3 bytes
    while (b < max)
    {
        *(char *)b++ = 0;
    }
}
