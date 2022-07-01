#include "lib.h"

void gettree(int depth, char *path);

void umain(int argc, char **argv)
{
    char *dirname;

    if (argc > 2)
    {
        fwritef(1, "usage: tree [dir]\n");
        exit();
    }
    dirname = (argc == 1) ? "/" : argv[1];
    gettree(0, dirname);
}

void print_tab(int num)
{
    int i;
    for (i = 0; i < num; i++)
    {
        fwritef(1, "    ");
    }
}

// ensure that path is a path of dir
void gettree(int depth, char *path)
{
    struct Fd *fd;
    struct Filefd *fileFd;
    int i;

    int r = open(path, O_RDONLY);
    if (r < 0)
        return;

    fd = (struct Fd *)num2fd(r);
    fileFd = (struct Filefd *)fd;
    u_int size = fileFd->f_file.f_size;
    //    print_tab(depth);
    fwritef(1, "\x1b[34m%s\x1b[0m\n", fileFd->f_file.f_name);

    u_int num = ROUND(size, sizeof(struct File)) / sizeof(struct File);
    struct File *file = (struct File *)fd2data(fd);
    /*
    dir
    |---dir1
    |---dir2
        |---dir3
    */

    for (i = 0; i < num; i++)
    {
        if (file[i].f_name[0] == '\0')
            continue;
        print_tab(depth);
        fwritef(1, "|---");
        if (file[i].f_type == FTYPE_DIR)
        {
            char newpath[MAXPATHLEN];
            // tree
            strcpy(newpath, path);
            int len = strlen(path);
            if (newpath[len - 1] != '/')
                *(newpath + len++) = '/';
            strcpy(newpath + len, (const char *)file[i].f_name);
            //                      writef("npath: %s", newpath);
            gettree(depth + 1, newpath);
        }
        else
        {
            fwritef(1, "%s\n", file[i].f_name);
        }
    }
}
