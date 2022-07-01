#include "lib.h"

void umain(void)
{
    int fd, n, r;
    char buf[2048 + 1];

    if ((fd = open("/name", O_RDONLY)) < 0)
    {
        user_panic("icode: open /name: %e", fd);
    }

    while ((n = read(fd, buf, sizeof buf - 1)) > 0)
    {
        buf[n] = 0;
        writef("%s\n", buf);
    }


    if ((r = spawnl("init.b", "init", "initarg1", "initarg2", (char *)0)) < 0)
    {
        user_panic("icode: spawn /init: %e", r);
    }
}
