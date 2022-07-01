#include "lib.h"

void umain(int argc, char **argv)
{
    int i;
    for (i = 0; i < argc; i++)
    {
        fwritef(1, "'''''''' %s '''''''''\n", argv[i]);
    }
}
