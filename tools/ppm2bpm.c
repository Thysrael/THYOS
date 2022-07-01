#include <stdio.h>
#include <stdint.h>

struct bpm_header
{
    uint32_t magic_num; // 0xbade0dff
    uint32_t width;
    uint32_t length;
};

int main(int argc, char *argv[])
{
    if (argc <= 1)
    {
        printf("No input file!\n");
        return -1;
    }
    if (argc <= 2)
    {
        printf("No output file!\n");
        return -1;
    }

    FILE *input_file = fopen(argv[1], "r");
    FILE *output_file = fopen(argv[2], "w");
    int width, length, depth;
    char buf[128];
    fscanf(input_file, "%s%d%d%d", buf, &width, &length, &depth);
    struct bpm_header head = {0xbade0dff, width, length};
    fwrite(&head, sizeof(struct bpm_header), 1, output_file);
    int color[3];
    int cnt = 0;
    int char_num;
    while ((char_num = fscanf(input_file, "%d%d%d", color, color + 1, color + 2)) != EOF)
    {
        if (char_num == 0)
        {
            goto binary_mode;
        }
        cnt++;
        for (int i = 0; i < 3; i++)
            color[i] = color[i] * 255 / depth;
        int comp = (0xff << 24 | color[0] << 0 | color[1] << 8 | color[2] << 16);
        fwrite(&comp, sizeof(int), 1, output_file);
    }
    printf("Converted finish with %d pixel.\n", cnt);
    return 0;
binary_mode:
    color[0] = fgetc(input_file);
    while (1)
    {
        color[0] = fgetc(input_file);
        if (color[0] == EOF)
        {
            break;
        }
        cnt++;
        color[1] = fgetc(input_file);
        color[2] = fgetc(input_file);
        int comp = (0xff << 24 | color[2] << 0 | color[0] << 8 | color[1] << 16);
        fwrite(&comp, sizeof(int), 1, output_file);
    }
    printf("Converted finish with %d pixel.\n", cnt);
    return 0;
}
