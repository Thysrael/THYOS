#include "lib.h"

#define TMPPAGETOP (2 * BY2PG)
#define TMPPAGE (BY2PG)

int init_stack(u_int child, char **argv, uint_64 *init_esp, uint_64 *argc_in_reg, uint_64 *argv_in_reg)
{
	int argc, i, r, tot;
	char *strings;
	uint_64 *args;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (tot)
	tot = 0;
	for (argc = 0; argv[argc]; argc++)
		tot += strlen(argv[argc]) + 1;

	// Make sure everything will fit in the initial stack page
	if (ROUND(tot, 16) + ROUND((argc + 1) * 8, 16) > BY2PG)
		return -E_NO_MEM;

	// Determine where to place the strings and the args array
	strings = (char *)TMPPAGETOP - tot;
	args = (u_int *)(TMPPAGETOP - ROUND(tot, 16) - ROUND((argc + 1) * 8, 16));

	if ((r = syscall_mem_alloc(0, TMPPAGE, PTE_VALID)) < 0)
		return r;
	// Replace this with your code to:
	//
	//	- copy the argument strings into the stack page at 'strings'
	char *ctemp, *argv_temp;
	uint_64 j;
	ctemp = strings;
	for (i = 0; i < argc; i++)
	{
		j = USTACKTOP - TMPPAGETOP + (uint_64)strings;
		argv_temp = argv[i];
		args[i] = j;
		for (; *argv_temp; j++)
		{
			*ctemp = *argv_temp;
			ctemp++;
			argv_temp++;
		}
		*ctemp = 0;
		ctemp++;
		j++;
	}
	//	- initialize args[0..argc-1] to be pointers to these strings
	//	  that will be valid addresses for the child environment
	//	  (for whom this page will be at USTACKTOP-BY2PG!).
	//	- set args[argc] to 0 to null-terminate the args array.
	args[argc] = 0;

	//
	//	- set *init_esp to the initial stack pointer for the child
	//
	*init_esp = USTACKTOP - TMPPAGETOP + (uint_64)args;
	*argc_in_reg = argc;
	*argv_in_reg = USTACKTOP - TMPPAGETOP + (uint_64)args;
	//	*init_esp = USTACKTOP;	// Change this!

	if ((r = syscall_mem_map(0, TMPPAGE, child, USTACKTOP - BY2PG, PTE_VALID)) < 0)
		goto error;
	if ((r = syscall_mem_unmap(0, TMPPAGE)) < 0)
		goto error;

	return 0;

error:
	syscall_mem_unmap(0, TMPPAGE);
	return r;
}