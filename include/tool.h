#ifndef _TOOL_H_
#define _TOOL_H_

// tool.c
void alouha();

void print_stack();

void print_exception_level();

void bcopy(const void *src, void *dst, unsigned long len);

void bzero(void *b, unsigned long len);

void ent_handler(int type, unsigned long esr, unsigned long address);

// asm_tool.S

long get_EL();

void put32(long, long);

void enable_interrupt_controller();


// macro function

#define MIN(_a, _b)             \
    ({                          \
        typeof(_a) __a = (_a);  \
        typeof(_b) __b = (_b);  \
        __a <= __b ? __a : __b; \
    })

#endif