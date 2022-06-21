/*

这个文件中主要是一些难以分类，而且工具性较强的 C 函数。

*/

#include "tool.h"
#include "printf.h"
#include "types.h"

const char *entry_error_messages[] = 
{
    "SYNC_INVALID_EL1t",
    "IRQ_INVALID_EL1t",
    "FIQ_INVALID_EL1t",
    "ERROR_INVALID_EL1T",

    "SYNC_INVALID_EL1h",
    "IRQ_INVALID_EL1h",
    "FIQ_INVALID_EL1h",
    "ERROR_INVALID_EL1h",

    "SYNC_INVALID_EL0_64",
    "IRQ_INVALID_EL0_64",
    "FIQ_INVALID_EL0_64",
    "ERROR_INVALID_EL0_64",

    "SYNC_INVALID_EL0_32",
    "IRQ_INVALID_EL0_32",
    "FIQ_INVALID_EL0_32",
    "ERROR_INVALID_EL0_32"
};

void alouha()
{
    printf("alouha... \n");
}

void print_stack()
{
    int tmp;
    printf("Kernel stack base at 0x%lx.\n", &tmp);
}

void print_exception_level()
{
    printf("Current exception level switched to Level %d.\n", get_EL());
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

void unimplement_handler(int type, unsigned long esr, unsigned long address)
{
    uint_64 EC = esr >> 26;
    printf("EC is 0x%lx.\n", EC);
    printf("%s, ESR: %x, bad address: %x\r\n", entry_error_messages[type], esr, address);
    panic("unimplement exception raised!\r\n");
}

void enable_interrupt_controller()
{
    // enable all kind of exception!
    // as for the register mapping,see guidebook.
    put32((0xffffff8040000040), (0xf));
    put32((0xffffff8040000044), (0xf));
    put32((0xffffff8040000048), (0xf));
    put32((0xffffff804000004c), (0xf));
}