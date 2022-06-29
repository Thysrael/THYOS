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
void
ide_read(u_int diskno, u_int secno, void *dst, u_int nsecs)
{
	// 0x200: the size of a sector: 512 bytes.
	int offset_begin = secno * 0x200;
	int offset_end = offset_begin + nsecs * 0x200;
	int offset = 0;
	int stack_data_temp = 0;
	//writef("Start to write dist %d in %d shift \n",diskno,secno);
	while (offset_begin + offset < offset_end) {
		stack_data_temp = diskno;
		syscall_write_dev(&stack_data_temp, 0x13000010,4);
                stack_data_temp = offset_begin + offset;
		syscall_write_dev(&stack_data_temp, 0x13000000,4);
		stack_data_temp = 0;
		syscall_write_dev(&stack_data_temp, 0x13000020,4);
		
		int cnt = 0;
		while(stack_data_temp == 0)
		{
			syscall_read_dev(&stack_data_temp, 0x13000030,4);
			break;
			cnt ++;
			if(cnt >5)
				user_panic("Too many error in ide read");
		}
		syscall_read_dev(dst + offset, 0x13004000, 512);
		offset += 512;
		// Your code here
		// error occurred, then panic.
	}
}
/*void ide_read(u_int diskno, u_int secno, void *dst, u_int nsecs)
{
	// 0x200: the size of a sector: 512 bytes.
	int offset_begin = secno * 0x200;
	int offset_end = offset_begin + nsecs * 0x200;
	int offset = 0;

	u_int zero = 0;
	u_int cur_offset = 0;

	while (offset_begin + offset < offset_end)
	{
		// Your code here
		// error occurred, then panic.
		cur_offset = offset_begin + offset;
		if (syscall_write_dev((u_int)&diskno, 0x13000010, 4) < 0)
			user_panic("ide_read panic");
		if (syscall_write_dev((u_int)&cur_offset, 0x13000000, 4) < 0)
			user_panic("ide_read panic");
		if (syscall_write_dev((u_int)&zero, 0x13000020, 4) < 0)
			user_panic("ide_read panic");
		u_int succ;
		if (syscall_read_dev((u_int)&succ, 0x13000030, 4) < 0)
			user_panic("ide_read panic");
		if (!succ)
			user_panic("ide_read panic");
		if (syscall_read_dev((u_int)(dst + offset), 0x13004000, 0x200) < 0)
			user_panic("ide_read panic");
		offset += 0x200;
	}
}*/


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
/*** exercise 5.2 ***/
void
ide_write(u_int diskno, u_int secno, void *src, u_int nsecs)
{
	// Your code here
	// int offset_begin = ;
	// int offset_end = ;
	// int offset = ;

	// DO NOT DELETE WRITEF !!!
	writef("diskno: %d\n", diskno);

	// while ( < ) {
		// copy data from source array to disk buffer.

		// if error occur, then panic.
	// }
	int ret;
	int offset_begin = secno * 0x200;
        int offset_end = offset_begin + nsecs * 0x200;
        int offset = 0;
        int stack_data_temp = 0;
        while (offset_begin + offset < offset_end) {
                stack_data_temp = diskno;
                ret = syscall_write_dev(&stack_data_temp, 0x13000010,4);
                if(ret < 0)
		{
			user_panic("Ide write error!");
			//return ret;
		}
		stack_data_temp = offset_begin + offset;
                ret = syscall_write_dev(&stack_data_temp, 0x13000000,4);
                if(ret < 0)
		{
			user_panic("Ide write error!");
			//return ret;
		}
		ret = syscall_write_dev(src + offset, 0x13004000, 512);
		if(ret < 0)
		{
			user_panic("Ide write error!");
			//return ret;
		}

		stack_data_temp = 1;
                ret = syscall_write_dev(&stack_data_temp, 0x13000020,4);
		if(ret < 0)
		{
			user_panic("Ide write error!");
			//return ret;
		}

                int cnt = 0;
		stack_data_temp = 0;
                while(stack_data_temp == 0)
                {       
                        syscall_read_dev(&stack_data_temp, 0x13000030,4);
                        break;
			cnt ++;
                        if(cnt >5)
                                user_panic("Too many error in ide write");
                }
                offset += 512;
                // Your code here
                // error occurred, then panic.
        }

}
/*void ide_write(u_int diskno, u_int secno, void *src, u_int nsecs)
{
	// Your code here
	int offset_begin = secno * 0x200;
	int offset_end = offset_begin + nsecs * 0x200;
	int offset = 0;

	u_int one = 1;
	u_int cur_offset = 0;

	// DO NOT DELETE WRITEF !!!
	// writef("diskno: %d\n", diskno);

	while (offset_begin + offset < offset_end)
	{
		// copy data from source array to disk buffer.
		// if error occur, then panic.
		cur_offset = offset_begin + offset;
		if (syscall_write_dev((u_int)(src + offset), 0x13004000, 0x200) < 0)
			user_panic("ide_write panic");
		if (syscall_write_dev((u_int)&diskno, 0x13000010, 4) < 0)
			user_panic("ide_write panic");
		if (syscall_write_dev((u_int)&cur_offset, 0x13000000, 4) < 0)
			user_panic("ide_write panic");
		if (syscall_write_dev((u_int)&one, 0x13000020, 4) < 0)
			user_panic("ide_write panic");
		u_int succ;
		if (syscall_read_dev((u_int)&succ, 0x13000030, 4) < 0)
			user_panic("ide_write panic");
		offset += 0x200;
	}
}
*/
