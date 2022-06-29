/*
 * operations on IDE disk.
 */

#include "fs.h"
#include "lib.h"
#include <mmu.h>

// Overview:
// 	read data from IDE disk. First issue a read request through
// 	disk register and then copy data from disk buffer
// 	(512 bytes, a sector) to destination array.
//
// Parameters:
//	diskno: disk number.
// 	secno: start sector number.
// 	dst: destination for data read from IDE disk.
// 	nsecs: the number of sectors to read.
//
// Post-Condition:
// 	If error occurrs during the read of the IDE disk, panic.
//
// Hint: use syscalls to access device registers and buffers
/*** exercise 5.2 ***/
void ide_read(u_int diskno, u_int secno, void *dst, u_int nsecs)
{
	for (int i = 0; i < nsecs; i++)
	{
		syscall_read_sd(secno + i, dst + 512 * i);
	}
}

// Overview:
// 	write data to IDE disk.
//
// Parameters:
//	diskno: disk number.
//	secno: start sector number.
// 	src: the source data to write into IDE disk.
//	nsecs: the number of sectors to write.
//
// Post-Condition:
//	If error occurrs during the read of the IDE disk, panic.
//
// Hint: use syscalls to access device registers and buffers
void ide_write(u_int diskno, u_int secno, void *src, u_int nsecs)
{
	for (int i = 0; i < nsecs; i++)
	{
		syscall_write_sd(secno + i, src + 512 * i);
	}
}
