/*

这个文件用于存放用户态的输出函数。

基本上和内核态的实现逻辑一致，只是添加了系统调用。

*/

#include "lib.h"

void halt(void);

static void user_myoutput(void *arg, const char *s, int l)
{
    int i;

    // special termination call
    if ((l == 1) && (s[0] == '\0'))
    {
        return;
    }

    for (i = 0; i < l; i++)
    {
        syscall_putchar(s[i]);
    }
}

void writef(char *fmt, ...)
{
    va_list ap;
    va_start(ap, fmt);
    user_lp_Print(user_myoutput, 0, fmt, ap);
    va_end(ap);
}

void debug_printf(char *src, int line, char *fmt, ...)
{
    if (DEBUG)
    {
        writef("[DEBUG_INFO] %s @ %d: ", src, line);
        va_list ap;
        va_start(ap, fmt);
        user_lp_Print(user_myoutput, 0, fmt, ap);
        va_end(ap);
    }
}

void _user_panic(const char *file, int line, const char *fmt, ...)
{
    va_list ap;

    va_start(ap, fmt);
    writef("panic at %s:%d: ", file, line);
    user_lp_Print(user_myoutput, 0, (char *)fmt, ap);
    writef("\n");
    va_end(ap);

    exit();
}
