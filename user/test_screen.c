#include "lib.h"

int user_screen_buf[256][256];

int umain()
{
    for (int y = 0; y < 256; y++)
    {
        for (int x = 0; x < 256; x++)
        {
            user_screen_buf[y][x] = 0x7fffffff;
        }
    }
    syscall_draw_area(100, 100, 256, 256, (unsigned char *)user_screen_buf);
    return 0;
}