#include "lib.h"
#include "load.h"
#include "tool.h"

#define TMPPAGETOP      (2 * BY2PG)
#define TMPPAGE         (BY2PG)

int init_stack(u_int child, char **argv, uint_64 *init_esp, 
        uint_64 *argc_in_reg, uint_64 *argv_in_reg)
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
    args = (uint_64 *)(TMPPAGETOP - ROUND(tot, 16) - ROUND((argc + 1) * 8, 16));

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

int usr_is_elf_format(u_char *binary)
{
    Elf64_Ehdr *ehdr = (Elf64_Ehdr *)binary;

    if (ehdr->e_ident[0] == EI_MAG0 &&
        ehdr->e_ident[1] == EI_MAG1 &&
        ehdr->e_ident[2] == EI_MAG2 &&
        ehdr->e_ident[3] == EI_MAG3)
    {
        return 0;
    }

    return 1;
}

// 这就拷加载一个段
int usr_load_elf(int fd, Elf64_Phdr *ph, int child_envid)
{
    // Hint: maybe this function is useful
    //       If you want to use this func, you should fill it ,it's not hard
    uint_64 va = ph->p_vaddr;
    uint_64 sgsize = ph->p_memsz;
    uint_64 bin_size = ph->p_filesz;
    u_char *bin;
    uint_64 i;
    int r;
    u_long offset = va - ROUNDDOWN(va, BY2PG);

    r = read_map(fd, ph->p_offset, (void *)&bin);
    if (r < 0)
    {
        return r;
    }

    if (offset != 0)
    {
        if ((r = syscall_mem_alloc(child_envid, va, PTE_VALID)) < 0)
        {
            return r;
        }
        if ((r = syscall_mem_map(child_envid, va, 0, USTACKTOP, PTE_VALID)) < 0)
        {
            return r;
        }
        // 又用这里做中转了
        user_bcopy(bin, (void *)(USTACKTOP + offset), MIN(BY2PG - offset, bin_size));
        if ((r = syscall_mem_unmap(0, USTACKTOP)) < 0)
        {
            return r;
        }
    }
    for (i = offset ? MIN(BY2PG - offset, bin_size) : 0; i < bin_size; i += BY2PG)
    {
        if ((r = syscall_mem_alloc(child_envid, va + i, PTE_VALID)) < 0)
        {
            return r;
        }
        if ((r = syscall_mem_map(child_envid, va + i, 0, USTACKTOP, PTE_VALID)) < 0)
        {
            return r;
        }
        user_bcopy(bin + i, (void *)USTACKTOP, MIN(BY2PG, bin_size - i));
        if ((r = syscall_mem_unmap(0, USTACKTOP)) < 0)
        {
            return r;
        }
    }

    while (i < sgsize)
    {
        if ((r = syscall_mem_alloc(child_envid, va + i, PTE_VALID)) < 0)
        {
            return r;
        }
        i += BY2PG;
    }
    return 0;
}

int spawn(char *prog, char **argv)
{
    // Note 0: some variable may be not used,you can cancel them as you like
    u_char elfbuf[512];
    int r;
    uint_64 fd;
    u_int child_envid;
    uint_16 size;
    uint_64 text_start;
    uint_64 esp;
    Elf64_Ehdr *elf;
    Elf64_Phdr *ph;
    uint_64 i, j, k, va;
    // Step 1: Open the file specified by `prog` (prog is the path of the program)
    if ((r = open(prog, O_RDONLY)) < 0)
    {
        user_panic("spawn ::open line 102 RDONLY wrong !\n");
        return r;
    }

    // Before Step 2 , You had better check the "target" spawned is a execute bin
    fd = r;
    if ((r = readn(fd, elfbuf, sizeof(Elf64_Ehdr))) < 0)
    {
        return r;
    }
    elf = (Elf64_Ehdr *)elfbuf;
    if (!usr_is_elf_format((u_char *)elf))
    {
        return -E_INVAL;
    }

    // Step 2: Allocate an env (Hint: using syscall_env_alloc())
    if ((r = msyscall(SYS_env_alloc, 0, 0, 0, 0, 0)) < 0)
    {
        return r;
    }
    if (r == 0)
    {
        env = envs + ENVX(syscall_getenvid());
        return 0;
    }
    child_envid = r;

    // Step 3: Using init_stack(...) to initialize the stack of the allocated env
    // init_stack(child_envid, argv, &esp);

    text_start = elf->e_phoff;
    size = elf->e_phentsize;
    for (i = 0; i < elf->e_phnum; i++)
    {
        if ((r = seek(fd, text_start)) < 0)
        {
            return r;
        }
        if ((r = readn(fd, elfbuf, size)) < 0)
        {
            return r;
        }
        ph = (Elf64_Phdr *)elfbuf;
        if (ph->p_type == PT_LOAD)
        {
            r = usr_load_elf(fd, ph, child_envid);
            if (r < 0)
            {
                return r;
            }
        }
        text_start += size;
    }


    struct Trapframe *tf;
    writef("\n::::::::::spawn size : %x  sp : %x::::::::\n", size, esp);
    tf = &(envs[ENVX(child_envid)].env_tf);
    tf->elr = 0x00400000;
    tf->sp = esp;

    // 上面只是加载了程序的代码段，后面还有文件描述符等东西需要加载
    for (i = 0; i <= PUDX(USTACKTOP); i++)
    {
        if ((vud[i] & PTE_VALID) == 0)
        {
            continue;
        }

        for (j = 0; j < 512; j++)
        {
            if ((vmd[(i << 9) + j] & PTE_VALID) == 0)
            {
                continue;
            }
            for (k = 0; k < 512; k++)
            {
                if ((vpt[(i << 18) + (j << 9) + k] & PTE_VALID) && 
                    ((vpt[(i << 18) + (j << 9) + k] & PTE_LIBRARY)) && 
                    ((((i << 18) + (j << 9) + k) << 12) < USTACKTOP))
                {
                    va = ((i << 18) + (j << 9) + k) << 12;
                    if ((r = syscall_mem_map(0, va, child_envid, va, (PTE_VALID | PTE_LIBRARY))) < 0)
                    {

                        user_panic("va: %x   child_envid: %x   \n", va, child_envid);
                        return r;
                    }
                }
            }
        }
    }

    if ((r = syscall_set_env_status(child_envid, ENV_RUNNABLE)) < 0)
    {
        user_panic("set child runnable is wrong\n");
        return r;
    }
    return child_envid;
}

int spawnl(char *prog, char *args, ...)
{
    return spawn(prog, &args);
}
