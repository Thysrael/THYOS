/*

这个文件主要是关于内存管理的内容。

主要的差异在于页表项权限位的不同。

*/


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
extern char init_sp[];
extern uint_64 *kernel_pud;

void mips_detect_memory()
{
    maxpa = PHY_TOP;
    basemem = PHY_TOP;
    npage = basemem / BY2PG;
    extmem = 0;
    printf("Physical memory: 0x%lxK available, ", (int)(maxpa / 1024));
    printf("base = 0x%lxK, extended = 0x%lxK.\n", (int)(basemem / 1024), (int)(extmem / 1024));
}

static void *alloc(uint_64 n, uint_64 align, int clear)
{
    u_long alloced_mem;
    // 这里完成对 freemem 的重定位，因为需要 freemem 在高地址发挥作用
    if (freemem < (uint_64)_end)
    {
        freemem = (uint_64)init_sp;
        printf("freemem has been adjusted to 0x%lx.\n", freemem);
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

    int_64 n;

    /* Step 2: Allocate proper size of physical memory for global array `pages`,
     * for physical memory management. Then, map virtual address `UPAGES` to
     * physical address `pages` allocated before. In consideration of alignment,
     * you should round up the memory size before map. */
    // "pages" is an global array
    pages = (struct Page *)alloc(npage * sizeof(struct Page), BY2PG, 1);
    printf("to memory %lx for struct Pages.\n", freemem);
    n = ROUND(npage * sizeof(struct Page), BY2PG);
    // map the 'pages' in virtual address space to the physical address space
    boot_map_segment(kernel_pud, UPAGES, n, PADDR(pages), PTE_VALID | PTE_RO);

    /* Step 3, Allocate proper size of physical memory for global array `envs`,
     * for process management. Then map the physical address to `UENVS`. */
    envs = (struct Env *)alloc(NENV * sizeof(struct Env), BY2PG, 1);
    printf("to memory %lx for struct Envs.\n", freemem);
    n = ROUND(NENV * sizeof(struct Env), BY2PG);
    boot_map_segment(kernel_pud, UENVS, n, PADDR(envs), PTE_VALID | PTE_RO);

    page_init();
    printf("pages and envs init success.\n");
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
    printf("There are %d pages has been used for the kernel.\n", size);
    /* Step 4: Mark the other memory as free. */
    for (i = size; i < npage; ++i)
    {
        pages[i].pp_ref = 0;
        LIST_INSERT_HEAD(&page_free_list, pages + i, pp_link);
    }
    printf("There are %d pages are free.\n", npage - size);
    // that's for the TIMESTACK, which store the data of old env.tf
    LIST_REMOVE(pa2page(PADDR(TIMESTACK - BY2PG)), pp_link);
    LIST_REMOVE(pa2page(PADDR(TIMESTACK - 2 * BY2PG)), pp_link);
    LIST_REMOVE(pa2page(PADDR(TIMESTACK - 3 * BY2PG)), pp_link);
    LIST_REMOVE(pa2page(PADDR(TIMESTACK - 4 * BY2PG)), pp_link);
    LIST_REMOVE(pa2page(PADDR(TIMESTACK - 5 * BY2PG)), pp_link);
    LIST_REMOVE(pa2page(PADDR(TIMESTACK - 6 * BY2PG)), pp_link);
    printf("Timestack is at the virtual address 0x%lx.\n", TIMESTACK);
    printf("Kernel stack base is at the virtual address 0x%lx.\n", KERNEL_SP);
}

int page_alloc(struct Page **pp)
{
    struct Page *ppage_temp;

    /* Step 1: Get a page from free memory. If fail, return the error code.*/
    if (LIST_EMPTY(&page_free_list))
    {
        return -E_NO_MEM;
    }
    ppage_temp = LIST_FIRST(&page_free_list);
    LIST_REMOVE(ppage_temp, pp_link);
    /* Step 2: Initialize this page.
     * Hint: use `bzero`. */
    bzero((void *)page2kva(ppage_temp), BY2PG);
    *pp = ppage_temp;
    return 0;
}

void page_free(struct Page *pp)
{
    /* Step 1: If there's still virtual address referring to this page, do nothing. */
    if (pp->pp_ref > 0)
    {
        return;
    }

    /* Step 2: If the `pp_ref` reaches 0, mark this page as free and return. */
    else if (pp->pp_ref == 0)
    {
        LIST_INSERT_HEAD(&page_free_list, pp, pp_link);
        return;
    }

    /* If the value of `pp_ref` is less than 0, some error must occurr before,
     * so PANIC !!! */
    panic("pp->pp_ref is less than zero\n");
}

int pgdir_walk(uint_64 *pud, uint_64 va, int create, uint_64 **ppte)
{
    struct Page *ppage;
    uint_64 *pud_entryp;
    uint_64 *pmd, *pmd_entryp;
    uint_64 *pte;

    // 首先看第一级页表项
    pud_entryp = pud + PUDX(va);
    printf("pud_entry is 0x%lx.\n", *pud_entryp);
    if (!((*pud_entryp) & PTE_VALID))
    {
        if (create)
        {
            if (page_alloc(&ppage) == -E_NO_MEM)
            {
                *ppte = NULL;
                return -E_NO_MEM;
            }
            else
            {
                ppage->pp_ref++;
                *pud_entryp = page2pa(ppage) | PTE_VALID | PTE_TABLE | PTE_AF | PTE_USER | PTE_ISH | PTE_NORMAL;
            }
        }
        else
        {
            *ppte = 0;
            return 0;
        }
    }

    // 然后看第二级页表项
    pmd = (uint_64 *)KADDR(PTE_ADDR(*pud_entryp));
    pmd_entryp = pmd + PMDX(va);
    printf("pmd_entry is 0x%lx.\n", *pmd_entryp);
    if (!((*pmd_entryp) & PTE_VALID))
    {
        if (create)
        {
            if (page_alloc(&ppage) == -E_NO_MEM)
            {
                *ppte = NULL;
                return -E_NO_MEM;
            }
            else
            {
                ppage->pp_ref++;
                *pmd_entryp = page2pa(ppage) | PTE_VALID | PTE_TABLE | PTE_AF | PTE_USER | PTE_ISH | PTE_NORMAL;
            }
        }
        else
        {
            *ppte = 0;
            return 0;
        }
    }

    // 最后看三级页表项
    pte = (uint_64 *)KADDR(PTE_ADDR(*pmd_entryp));
    *ppte = pte + PTEX(va);
    printf("pt_entry is 0x%lx.\n", **ppte);
    return 0;
}

int page_insert(uint_64 *pud, struct Page *pp, uint_64 va, uint_64 perm)
{
    uint_64 PERM;
    uint_64 *pgtable_entry;
    // 这里的 PERM 应该是对应第三级页表项，没有 PTE_TABLE
    PERM = perm | PTE_VALID | PTE_AF | PTE_USER | PTE_ISH | PTE_NORMAL;

    // Step 1: Get corresponding page table entry.
    pgdir_walk(pud, va, 0, &pgtable_entry);

    // pagetable_entry is exist and pagetable_entry is writable.
    if (pgtable_entry != 0 && (*pgtable_entry & PTE_VALID) != 0)
    {
        // If there is already a page mapped at `va`, call page_remove() to release this mapping.
        if (pa2page(*pgtable_entry) != pp)
        {
            page_remove(pud, va);
        }
        else
        {
            tlb_invalidate();
            *pgtable_entry = (page2pa(pp) | PERM);
            return 0;
        }
    }

    /* Step 2: Update TLB. */
    /* hint: use tlb_invalidate function */
    tlb_invalidate();

    /* Step 3: Do check, re-get page table entry to validate the insertion. */
    /* Step 3.1 Check if the page can be insert, if can’t return -E_NO_MEM */
    if (pgdir_walk(pud, va, 1, &pgtable_entry))
    {
        return -E_NO_MEM;
    }
    *pgtable_entry = page2pa(pp) | PERM;
    /* Step 3.2 Insert page and increment the pp_ref */
    pp->pp_ref++;

    return 0;
}

struct Page *page_lookup(uint_64 *pud, uint_64 va, uint_64 **ppte)
{
    struct Page *ppage;
    uint_64 *pte;

    /* Step 1: Get the page table entry. */
    pgdir_walk(pud, va, 0, &pte);

    /* Hint: Check if the page table entry doesn't exist or is not valid. */
    if (pte == 0)
    {
        return 0;
    }
    if ((*pte & PTE_VALID) == 0)
    {
        return 0; // the page is not in memory.
    }

    /* Step 2: Get the corresponding Page struct. */

    /* Hint: Use function `pa2page`, defined in include/pmap.h . */
    ppage = pa2page(*pte);
    if (ppte)
    {
        *ppte = pte;
    }

    return ppage;
}

void page_decref(struct Page *pp)
{
    if (--pp->pp_ref == 0)
    {
        page_free(pp);
    }
}

void page_remove(uint_64 *pud, uint_64 va)
{
    uint_64 *pagetable_entry;
    struct Page *ppage;

    /* Step 1: Get the page table entry, and check if the page table entry is valid. */
    ppage = page_lookup(pud, va, &pagetable_entry);

    if (ppage == 0)
    {
        return;
    }

    /* Step 2: Decrease `pp_ref` and decide if it's necessary to free this page. */

    /* Hint: When there's no virtual address mapped to this page, release it. */
    ppage->pp_ref--;
    if (ppage->pp_ref == 0)
    {
        page_free(ppage);
    }
    /* Step 3: Update TLB. */
    *pagetable_entry = 0;
    tlb_invalidate();
    return;
}

void pageout(uint_64 va, uint_64 *context)
{
    int r;
    struct Page *p = NULL;

    printf("pud address is 0x%lx.\n", context);

    uint_64 pud = (uint_64)context + KERNEL_BASE;

    if (va < 0x10000)
    {
        panic("^^^^^^TOO LOW^^^^^^^^^");
    }

    if ((r = page_alloc(&p)) < 0)
    {
        panic("page alloc error!");
    }

    page_insert(pud, p, VA2PFN(va), PTE_RW);
}