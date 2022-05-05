#include "pmap.h"
#include "mmu.h"
#include "printf.h"
#include "types.h"
#include "env.h"
#include "tool.h"

unsigned long maxpa;   /* Maximum physical address */
unsigned long npage;   /* Amount of memory(in pages) */
unsigned long basemem; /* Amount of base memory(in bytes) */
unsigned long extmem;  /* Amount of extended memory(in bytes) */

struct Page *pages;
static struct Page_list page_free_list;
extern uint_64 freemem;
extern char _end[];
extern char kernel_sp[];

void mips_detect_memory()
{
    maxpa = PHY_LIM;
    basemem = PHY_LIM;
    npage = basemem / BY2PG;
    extmem = 0;
    printf("Physical memory: 0x%lxK available, ", (int)(maxpa / 1024));
    printf("base = 0x%lxK, extended = 0x%lxK\n", (int)(basemem / 1024), (int)(extmem / 1024));
}

static void *alloc(uint_64 n, uint_64 align, int clear)
{
    u_long alloced_mem;
    // 这里完成对 freemem 的重定位，因为需要 freemem 在高地址发挥作用
    if (freemem < (uint_64)_end)
    {
        freemem = (uint_64)kernel_sp;
        printf("freemem has been adjusted to 0x%lx\n", freemem);
    }
    // Step 1: Round up `freemem` up to be aligned properly
    freemem = ROUND(freemem, align);
    // Step 2: Save current value of `freemem` as allocated chunk.
    alloced_mem = freemem;

    // Step 3: Increase `freemem` to record allocation.
    freemem = freemem + n;
    // Check if we're out of memory. If we are, PANIC !!
    if (PADDR(freemem) >= maxpa)
    {
        panic("out of memory\n");
        return (void *)-E_NO_MEM;
    }

    // Step 4: Clear allocated chunk if parameter `clear` is set.
    if (clear)
    {
        bzero((void *)alloced_mem, n);
    }

    // Step 5: return allocated chunk.
    return (void *)alloced_mem;
}

static uint_64 *boot_pgdir_walk(uint_64 *pud, uint_64 va, int create)
{
    uint_64 *pud_entryp;
    uint_64 *pmd, *pmd_entryp;
    uint_64 *pte, *pte_entryp;
    pud_entryp = pud + PUDX(va);
    pmd = (uint_64 *)(PTE_ADDR(*pud_entryp));
    if ((((*pud_entryp) & (PTE_VALID)) == 0))
    {
        if (create)
        {
            pmd = alloc(BY2PG, BY2PG, 1);
            *pud_entryp = (uint_64)pmd | PTE_VALID | PTE_TABLE | PTE_AF | PTE_USER | PTE_ISH | PTE_NORMAL;
        }
    }
    pmd_entryp = pmd + PMDX(va);
    pte = (uint_64 *)(PTE_ADDR(*pmd_entryp));
    if ((((*pmd_entryp) & (PTE_VALID)) == 0))
    {
        if (create)
        {
            pte = alloc(BY2PG, BY2PG, 1);
            *pmd_entryp = (uint_64)pte | PTE_VALID | PTE_TABLE | PTE_AF | PTE_USER | PTE_ISH | PTE_NORMAL;
        }
    }
    pte_entryp = pte + PTEX(va);
    return pte_entryp;
}

void boot_map_segment(uint_64 *pud, uint_64 va, uint_64 size, uint_64 pa, uint_64 perm)
{
    int i;
    uint_64 *pgtable_entry;

    // Step 1: Check if `size` is a multiple of BY2PG.
    size = ROUND(size, BY2PG);

    // Step 2: Map virtual address space to physical address.
    // Hint: Use `boot_pgdir_walk` to get the page table entry of virtual address `va`.
    for (i = 0; i < size; i += BY2PG)
    {
        pgtable_entry = boot_pgdir_walk(pud, va + i, 1);
        *pgtable_entry = PTE_ADDR(pa + i) | perm | PTE_VALID | PTE_TABLE | PTE_AF | PTE_USER | PTE_ISH | PTE_NORMAL;
    }
}

void arch_basic_init()
{
    extern struct Env *envs;

    //u_int n;

    /* Step 2: Allocate proper size of physical memory for global array `pages`,
     * for physical memory management. Then, map virtual address `UPAGES` to
     * physical address `pages` allocated before. In consideration of alignment,
     * you should round up the memory size before map. */
    // "pages" is an global array
    pages = (struct Page *)alloc(npage * sizeof(struct Page), BY2PG, 1);
    printf("to memory %lx for struct Pages.\n", freemem);
    //n = ROUND(npage * sizeof(struct Page), BY2PG);
    // map the 'pages' in virtual address space to the physical address space
    //boot_map_segment(pgdir, UPAGES, n, PADDR(pages), PTE_R);

    /* Step 3, Allocate proper size of physical memory for global array `envs`,
     * for process management. Then map the physical address to `UENVS`. */
    envs = (struct Env *)alloc(NENV * sizeof(struct Env), BY2PG, 1);
    printf("to memory %lx for struct Envs.\n", freemem);
    //n = ROUND(NENV * sizeof(struct Env), BY2PG);
    //boot_map_segment(pgdir, UENVS, n, PADDR(envs), PTE_R);

    page_init();
    printf("pages and envs init success\n");
}

void page_init()
{
    /* Step 1: Initialize page_free_list. */
    /* Hint: Use macro `LIST_INIT` defined in include/queue.h. */
    LIST_INIT(&page_free_list);

    /* Step 2: Align `freemem` up to multiple of BY2PG. */
    freemem = ROUND(freemem, BY2PG);

    /* Step 3: Mark all memory blow `freemem` as used(set `pp_ref`
     * filed to 1) */
    int size = PADDR(freemem) / BY2PG;
    int i;
    for (i = 0; i < size; ++i)
    {
        pages[i].pp_ref = 1;
    }

    /* Step 4: Mark the other memory as free. */
    for (i = size; i < npage; ++i)
    {
        pages[i].pp_ref = 0;
        LIST_INSERT_HEAD(&page_free_list, pages + i, pp_link);
    }
    // that's for the TIMESTACK, which store the data of old env.tf
    // LIST_REMOVE(pa2page(PADDR(TIMESTACK - BY2PG)), pp_link);
}