#include "lib.h"

void umain(int argc, char **argv)
{
    int i, fd;

    if (argc < 2) // check the number of arg
    {
        fwritef(1, "usage: touch [filename]\n");
        return;
    }

    for (i = 1; i < argc; i++)
    {
        fd = open(argv[i], O_RDONLY);
        if (fd >= 0)
        {
            fwritef(1, "file %s exists\n", argv[1]);
            return;
        }
        if (create(argv[1], FTYPE_REG) < 0)
        {
            fwritef(1, "failed to create!\n");
        }
    }
}
