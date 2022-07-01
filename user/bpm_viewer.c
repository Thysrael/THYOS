#include "lib.h"

#define FRAMEBUFFER_ADDRESS 0x2f00000000
int *frame_buffer = FRAMEBUFFER_ADDRESS;

void umain(int argc, char **argv)
{
    int f, i;

    if (argc == 1)
    {
        writef("No input file !\n");
        return;
    }
    int fd = open(argv[1], O_RDONLY);
    int magic, width, heigth;
    bread(fd, &magic, 4);
    if (magic != 0xbade0dff)
    {
        writef("Error file format!!\n");
        return;
    }
    bread(fd, &width, 4);
    bread(fd, &heigth, 4);
    writef("File size is %d %d\n", width, heigth);
    int pixel_size = width * heigth;
    int page_num = (pixel_size * 4 + BY2PG - 1) / BY2PG;
    for (int i = 0; i < page_num; i++)
    {
        syscall_mem_alloc(0, FRAMEBUFFER_ADDRESS + i * BY2PG, PTE_VALID);
    }
    for (int i = 0; i < pixel_size; i++)
    {
        bread(fd, frame_buffer + i, 4);
    }
    syscall_draw_area(0, 0, width, heigth, (unsigned char *)frame_buffer);
    return;
}
