#include "lib.h"

void umain(int argc, char **argv)
{
    if (argc != 2) // check the number of arg
    {
        fwritef(1, "usage: mkdir [filename]\n");
        return;
    }
    int fd = open(argv[1], O_RDONLY);
    if (fd >= 0)
    {
        fwritef(1, "file %s exists\n", argv[1]);
        return;
    }
    if (create(argv[1], FTYPE_DIR) < 0)
    {
        fwritef(1, "failed to create!\n");
    }
}
