#ifndef _PRINTF_H_
#define _PRINTF_H_

#include <stdarg.h>

void printf(char *fmt, ...);
void debug_printf(char *src, int line, char *fmt, ...);

void _panic(const char *, int, const char *, ...)
    __attribute__((noreturn));

#define panic(...) _panic(__FILE__, __LINE__, __VA_ARGS__)
#define debug(...) debug_printf(__FILE__, __LINE__, __VA_ARGS__)

#endif /* _printf_h_ */