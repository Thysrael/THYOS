/*

这个文件主要是与 ELF 加载相关的内容。

64 位的 ELF 格式与 32 位发生了一些变化，其集中体现在 load.h 中。

*/

#include "types.h"
#include "mmu.h"
#include "env.h"
#include "load.h"
#include "printf.h"
#include "pmap.h"
#include "tool.h"
/* Overview:
 *   Check whether it is a ELF file.
 *
 * Pre-Condition:
 *   binary must longer than 4 byte.
 *
 * Post-Condition:
 *   Return 0 if `binary` isn't an elf. Otherwise
 * return 1.
 */
int is_elf_format(u_char *binary)
{
    Elf64_Ehdr *ehdr = (Elf64_Ehdr *)binary;

    if (ehdr->e_ident[0] == EI_MAG0 &&
        ehdr->e_ident[1] == EI_MAG1 &&
        ehdr->e_ident[2] == EI_MAG2 &&
        ehdr->e_ident[3] == EI_MAG3)
    {
        panic("It's not the elf format.\n");
        return 0;
    }

    return 1;
}

// 这个函数拷贝一个段的内容
int load_icode_mapper(u_long va, u_long sgsize, u_char *bin, u_long bin_size, void *user_data)
{
    struct Env *env = (struct Env *)user_data;
    struct Page *p = NULL;
    u_long i;
    int r;
    u_long offset = va - ROUNDDOWN(va, BY2PG);

    if (offset != 0)
    {
        if ((r = page_alloc(&p)) != 0)
            return r;
        bcopy(bin, (void *)(page2kva(p) + offset), MIN(bin_size, BY2PG - offset));
        page_insert(env->env_pgdir, p, va, PTE_RW);
    }
    /*Step 1: load all content of bin into memory. */
    for (i = offset ? MIN(bin_size, BY2PG - offset) : 0; i < bin_size; i += BY2PG)
    {
        /* Hint: You should alloc a new page. */
        if ((r = page_alloc(&p)) != 0)
            return r;
        bcopy(bin + i, (void *)page2kva(p), MIN(bin_size - i, BY2PG));
        page_insert(env->env_pgdir, p, va + i, PTE_RW);
    }
    /*Step 2: alloc pages to reach `sgsize` when `bin_size` < `sgsize`.
     * hint: variable `i` has the value of `bin_size` now! */
    while (i < sgsize)
    {
        if ((r = page_alloc(&p)) != 0)
            return r;
        page_insert(env->env_pgdir, p, va + i, PTE_RW);
        i += BY2PG;
    }
    return 0;
}

// 这个函数完成对于 elf 文件全部的拷贝
int load_elf(u_char *binary, int size, uint_64 *entry_point, void *user_data,
             int (*map)(uint_64 va, uint_64 sgsize, u_char *bin, uint_64 bin_size, void *user_data))
{
    Elf64_Ehdr *ehdr = (Elf64_Ehdr *)binary;
    Elf64_Phdr *phdr = NULL;
    /*
     * As a loader, we just care about segment,
     * so we just parse program headers.
     */
    u_char *ptr_ph_table = NULL;
    uint_16 ph_entry_count;
    uint_16 ph_entry_size;
    int r;

    // check whether `binary` is a ELF file.
    if (size < 4 || !is_elf_format(binary))
    {
        return -1;
    }

    ptr_ph_table = binary + ehdr->e_phoff;
    ph_entry_count = ehdr->e_phnum;
    ph_entry_size = ehdr->e_phentsize;

    while (ph_entry_count--)
    {
        phdr = (Elf64_Phdr *)ptr_ph_table;

        if (phdr->p_type == PT_LOAD)
        {
            /* Real map all section at correct virtual address.Return < 0 if error. */
            /* Hint: Call the callback function you have achieved before. */
            phdr = (Elf64_Phdr *)ptr_ph_table;

            if (phdr->p_type == PT_LOAD)
            {
                printf("p_vaddr is 0x%lx\n", phdr->p_vaddr);
                printf("p_memsz is 0x%lx\n", phdr->p_memsz);
                printf("bin adress is 0x%lx\n", binary + phdr->p_offset);
                printf("file size is 0x%lx\n", phdr->p_filesz);
                /* Real map all section at correct virtual address.Return < 0 if error. */
                /* Hint: Call the callback function you have achieved before. */
                r = map(phdr->p_vaddr, phdr->p_memsz, binary + phdr->p_offset, phdr->p_filesz, user_data);
                if (r != 0)
                    return r;
            }

            ptr_ph_table += ph_entry_size;
        }

        ptr_ph_table += ph_entry_size;
    }

    *entry_point = ehdr->e_entry;
    return 0;
}


// 这个函数不止拷贝 elf，还完成了相关的进程控制块的设置
void load_icode(struct Env *e, u_char *binary, u_long size)
{
    printf("load begin.\n");
    /* Hint:
     *  You must figure out which permissions you'll need
     *  for the different mappings you create.
     *  Remember that the binary image is an a.out format image,
     *  which contains both text and data.
     */
    struct Page *p = NULL;
    u_long entry_point;
    int r;
    u_long perm;

    /* Step 1: alloc a page for the stack */
    if (page_alloc(&p) == -E_NO_MEM)
    {
        return;
    }

    /* Step 2: Use appropriate perm to set initial stack for new Env. */
    // the stack only one page ???
    /* Hint: Should the user-stack be writable? */
    perm = PTE_RW;
    r = page_insert(e->env_pgdir, p, USTACKTOP - BY2PG, perm);
    if (r == -E_NO_MEM)
        return;
    
    /* Step 3: load the binary using elf loader. */
    r = load_elf(binary, size, &entry_point, e, load_icode_mapper);
   
    if (r < 0)
        return;

    /* Step 4: Set CPU's PC register as appropriate value. */
    e->env_tf.elr = entry_point;
}