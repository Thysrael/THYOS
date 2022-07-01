#include "lib.h"

void umain(int argc, char **argv)
{
    int i, r;

    if (argc < 2) // check the number of arg
    {
        fwritef(1, "usage: move [filename]\n");
        return;
    }

    for (i = 1; i < argc; i++)
    {
        r = remove(argv[i]);
        if (r < 0)
        {
            fwritef(1, "remove %s failed\n", argv[i]);
        }
        else
        {
            fwritef(1, "remove %s success.\n", argv[i]);
        }
    }
}
