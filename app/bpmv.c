#include "lib.h"

#define FRAMEBUFFER_ADDRESS 0x2f00000000
#define BUFFED_LINE 2
int *frame_buffer = (int *)FRAMEBUFFER_ADDRESS;

void umain(int argc, char **argv)
{
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
    int page_num = (width * 4 * BUFFED_LINE + BY2PG - 1) / BY2PG;
    for (int i = 0; i < page_num; i++)
    {
        syscall_mem_alloc(0, FRAMEBUFFER_ADDRESS + i * BY2PG, PTE_VALID);
    }
    for (int j = 0; j < heigth; j += BUFFED_LINE)
    {
        int l;
        l = bread(fd, frame_buffer, 4 * width * BUFFED_LINE);
        syscall_draw_area(0, j, width, l / 4 / width, (unsigned char *)frame_buffer);
    }
    return;
}
