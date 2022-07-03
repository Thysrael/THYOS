#include "lib.h"
#include "font.h"

#define LINEHEIGHT (16)
#define LINEWIDTH (8)

#define SCREEN_L (24)
#define SCREEN_T (24)

#define SCREENWIDTH (1024 - (SCREEN_L * 2))
#define SCREENHEIGHT (768 - (SCREEN_T * 2))

#define MAXLENINCHAR ((SCREENHEIGHT) / (LINEHEIGHT))
#define MAXCHAR ((SCREENWIDTH) / (LINEWIDTH))

char ascii_info[(MAXLENINCHAR)][(MAXCHAR)];
int len_buffer[(LINEHEIGHT)][(LINEWIDTH) * (MAXCHAR)];

int start_line = 0;
int end_line = 0;

int color = 0xffffffff;
int transparent = 0x00000000;

#include "lib.h"

#define FRAMEBUFFER_ADDRESS 0x2f00000000
#define BUFFED_LINE 256
int *frame_buffer = (int *)FRAMEBUFFER_ADDRESS;

void background(int argc, char **argv)
{
    static int fd = -1;
    if (fd == -1)
        fd = open(argv[1], O_RDONLY);
    seek(fd, 0);
    int magic, width, heigth;
    bread(fd, &magic, 4);
    if (magic != 0xbade0dff)
    {
        writef("Error file format!!\n");
        return;
    }
    bread(fd, &width, 4);
    bread(fd, &heigth, 4);
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

void print_char(int _id, int x)
{
    // writef("%d ", _id);
    int char_id = _id - 0x20;
    if (char_id < 0 || char_id > 94)
    {
        char_id = 0;
    }
    // writef("%d\n", char_id);
    for (int _y = 0; _y < LINEHEIGHT; _y++)
    {
        for (int _x = 0; _x < LINEWIDTH; _x++)
        {
            len_buffer[_y][_x + x] = ((font[char_id][_y] >> ((LINEWIDTH - 1 - _x) % 8)) & 1) == 1 ? color : transparent;
        }
    }
}

void prepare_line(int _id)
{
    int id = _id % MAXLENINCHAR;
    int i;
    for (i = 0; i < MAXCHAR; i++)
    {
        if (ascii_info[id][i] == 0)
            break;
        print_char(ascii_info[id][i], i * LINEWIDTH);
    }
    for (; i < MAXCHAR; i++)
    {
        for (int _y = 0; _y < LINEHEIGHT; _y++)
        {
            for (int _x = 0; _x < LINEWIDTH; _x++)
            {
                len_buffer[_y][_x + i * LINEWIDTH] = transparent;
            }
        }
    }
}

char *default_arg[] = {NULL, "pic.bpm"};
char **argv_bpmv = &default_arg;

void update()
{
    static int old_len = 0;
    if (old_len != start_line)
        if (argv_bpmv)
            background(2, argv_bpmv);
    old_len = start_line;
    for (int l = start_line; l <= end_line; l++)
    {
        int pl = l % MAXLENINCHAR;
        prepare_line(l);
        syscall_draw_area(SCREEN_L, SCREEN_T + ((l - start_line) * LINEHEIGHT), (LINEWIDTH) * (MAXCHAR), LINEHEIGHT, (unsigned char *)len_buffer);
    }
}

void umain(int argc, char *argv[])
{
    if (argc == 2)
    {
        argv_bpmv = argv;
    }
    if (argv_bpmv)
        background(2, argv_bpmv);
    int n;
    char buf_arr[4096];
    int char_num = 0;
    int cnt = 0;
    int is_changing_style = 0;
    while ((n = bread(STDIN_FILENO, buf_arr, 4096)) > 0)
    {
        for (int i = 0; i < n; i++)
        {
            char buf = buf_arr[i];
            if (is_changing_style)
            {
                if ((buf >= 'a' && buf <= 'z') || (buf >= 'A' && buf <= 'Z'))
                {
                    is_changing_style = 0;
                }
                continue;
            }
            if (buf == '\x1b')
            {
                is_changing_style = 1;
            }
            cnt++;
            if (buf == '\n')
            {
                end_line += 1;
                while (end_line - start_line > MAXLENINCHAR)
                    start_line += 1;
                char_num = 0;
                continue;
            }
            if (buf == '\r')
            {
                char_num = 0;
                continue;
            }
            if (buf == 0x8)
            {
                char_num--;
                if (char_num < 0)
                    char_num = 0;
                ascii_info[end_line % MAXLENINCHAR][char_num] = 0;
            }
            ascii_info[end_line % MAXLENINCHAR][char_num] = buf;
            char_num += 1;
            if (char_num >= MAXCHAR)
            {
                end_line += 1;
                while (end_line - start_line > MAXLENINCHAR)
                    start_line += 1;
                char_num = 0;
            }
            else
            {
                ascii_info[end_line % MAXLENINCHAR][char_num] = 0;
            }
        }
        if (char_num < MAXCHAR)
        {
            ascii_info[end_line % MAXLENINCHAR][char_num] = 0;
        }
        update();
    }
    writef("screen printer is exiting...\n printed %d char\n", cnt);
}
