#include "lib.h"
char buf[512], buf2[512];

void umain(int argc, char **argv)
{
	int fd;
	fd = opencons();
	write(fd, "hello world!", 12);
	int buf[128];
	while (read(fd, buf, 1) != 0)
	{
		writef("we got char %d \n", buf[0]);
		if (buf[0] == 'Q')
			break;
	}
	exit();
}
