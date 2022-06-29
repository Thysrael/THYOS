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

uint_64 maxpa;   /* Maximum physical address */
uint_64 npage;   /* Amount of memory(in pages) */
uint_64 basemem; /* Amount of base memory(in bytes) */
uint_64 extmem;  /* Amount of extended memory(in bytes) */

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
    printf("Physical memory: 0x%lx pages available, ", (maxpa / BY2PG));
    printf("base = 0x%lx pages, extended = 0x%lx pages.\n", (basemem / BY2PG), (extmem / BY2PG));
}

static void *alloc(uint_64 n, uint_64 align, int clear)
{
    uint_64 alloced_mem;

    // 这里完成对 freemem 的重定位，因为需要 freemem 在高地址发挥作用
    if (freemem < (uint_64)_end)
    {
        freemem = (uint_64)init_sp;
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

    // printf("alloced memory is 0x%lx\n", alloced_mem);
    // Step 5: return allocated chunk.
    return (void *)alloced_mem;
}

static uint_64 *boot_pgdir_walk(uint_64 *pud, uint_64 va, int create)
{
    uint_64 *pud_entryp;
    uint_64 *pmd, *pmd_entryp;
    uint_64 *pt, *pt_entryp;

    pud_entryp = pud + PUDX(va);
    pmd = (uint_64 *)KADDR((PTE_ADDR(*pud_entryp)));
    if ((((*pud_entryp) & (PTE_VALID)) == 0))
    {
        if (create)
        {
            pmd = alloc(BY2PG, BY2PG, 1);
            *pud_entryp = PADDR((uint_64)pmd) | PTE_VALID | PTE_TABLE | PTE_AF | PTE_USER | PTE_ISH | PTE_NORMAL;
        }
    }

    pmd_entryp = pmd + PMDX(va);
    pt = (uint_64 *)KADDR((PTE_ADDR(*pmd_entryp)));
    if ((((*pmd_entryp) & (PTE_VALID)) == 0))
    {
        if (create)
        {
            pt = alloc(BY2PG, BY2PG, 1);
            *pmd_entryp = PADDR((uint_64)pt) | PTE_VALID | PTE_TABLE | PTE_AF | PTE_USER | PTE_ISH | PTE_NORMAL;
        }
    }

    pt_entryp = pt + PTEX(va);
    return pt_entryp;
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
        *pgtable_entry = PTE_ADDR(pa + i) | perm | PTE_VALID | PTE_AF | PTE_USER | PTE_ISH | PTE_NORMAL | PTE_TABLE;
    }
}

void arch_basic_init()
{
    extern struct Env *envs;

    int_64 n;

    // 在这里要完成对于 kernel_pud 的重定位
    kernel_pud = (uint_64 *)KADDR((uint_64) kernel_pud);
    // "pages" is an global array
    pages = (struct Page *)alloc(npage * sizeof(struct Page), BY2PG, 1);
    n = ROUND(npage * sizeof(struct Page), BY2PG);
    // map the 'pages' in virtual address space to the physical address space
    boot_map_segment(kernel_pud, UPAGES, n, PADDR(pages), PTE_VALID | PTE_RO);

    /* Step 3, Allocate proper size of physical memory for global array `envs`,
     * for process management. Then map the physical address to `UENVS`. */
    envs = (struct Env *)alloc(NENV * sizeof(struct Env), BY2PG, 1);
    n = ROUND(NENV * sizeof(struct Env), BY2PG);
    boot_map_segment(kernel_pud, UENVS, n, PADDR(envs), PTE_VALID | PTE_RO);

    page_init();
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
    for (i = npage - 1; i >= size; --i)
    {
        pages[i].pp_ref = 0;
        LIST_INSERT_HEAD(&page_free_list, pages + i, pp_link);
    }
    printf("There are %d pages are free.\n", npage - size);

    // 这里没有采用原有的 list_remove，我觉得这样写更好
    // that's for the TIMESTACK, which store the data of old env.tf
    page_insert(kernel_pud, pa2page(PADDR(TIMESTACK - BY2PG)), TIMESTACK - BY2PG, PTE_VALID);
    // 这是 kernel stack
    page_insert(kernel_pud, pa2page(PADDR(KERNEL_SP - BY2PG)), KERNEL_SP - BY2PG, PTE_VALID);
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

    //Initialize this page.
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
    *ppte = NULL;
    
    // 首先看第一级页表项
    pud_entryp = pud + PUDX(va);

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
                ppage->pp_ref = 1;
                *pud_entryp = page2pa(ppage) | PTE_VALID | PTE_TABLE | PTE_NORMAL | PTE_USER | PTE_AF | PTE_ISH;
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
                ppage->pp_ref = 1;
                *pmd_entryp = page2pa(ppage) | PTE_VALID | PTE_TABLE | PTE_NORMAL | PTE_USER | PTE_AF | PTE_ISH;
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

    return 0;
}

int page_insert(uint_64 *pud, struct Page *pp, uint_64 va, uint_64 perm)
{
    debug("Wanna to insert page at pa 0x%lx to va 0x%lx\n", page2pa(pp), va);
    uint_64 PERM;
    uint_64 *pgtable_entry = NULL;
    // 这里的 PERM 应该是对应第三级页表项，没有 PTE_TABLE
    // 上面说错了，上面的认知应该来自指导书，指导书是错的，或者他用的是 block，这里是对的
    PERM = perm | PTE_VALID | PTE_NORMAL | PTE_AF | PTE_USER | PTE_ISH | PTE_TABLE;
    // Step 1: Get corresponding page table entry.
    pgdir_walk(pud, va, 0, &pgtable_entry);
    // pagetable_entry is exist and pagetable_entry is writable.
    if (pgtable_entry != 0 && (*pgtable_entry & PTE_VALID) != 0)
    {
        // If there is already a page mapped at `va`, call page_remove() to release this mapping.
        if (pe2page(*pgtable_entry) != pp)
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

    /* Step 3: Do check, re-get page table entry to validate the insertion. */
    /* Step 3.1 Check if the page can be insert, if can’t return -E_NO_MEM */
    if (pgdir_walk(pud, va, 1, &pgtable_entry))
    {
        return -E_NO_MEM;
    }
    *pgtable_entry = page2pa(pp) | PERM;
    /* Step 3.2 Insert page and increment the pp_ref */
    pp->pp_ref++;
    tlb_invalidate();

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
    ppage = pe2page(*pte);
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
    debug("Wanna to remove page at pa 0x%lx to va 0x%lx\n", page2pa(ppage), va);
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

    uint_64* pud = (uint_64 *)KADDR((uint_64)context);

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

void debug_print_pgdir(uint_64 *pg_root)
{
    debug("start to retrieval address: %lx\n", pg_root);
    // We only print the first 16 casting
    int limit = 2048;
    for (uint_64 i = 0; i < 512; i++)
    {
        // First Level
        uint_64 pg_info = pg_root[i];
        if (pg_info & PTE_VALID)
        {
            debug("|-Level1 OK %lx|\n", pg_info);
            // So we should go to level 2
            uint_64 *level2_root = (uint_64 *)KADDR(PTE_ADDR(pg_info));
            for (uint_64 j = 0; j < 512; j++)
            {
                uint_64 level2_info = level2_root[j];
                if (level2_info & PTE_VALID)
                {
                    debug("|-|-Level2 OK|\n");
                    // So we should go to level 3
                    uint_64 *level3_root = (uint_64 *)KADDR(PTE_ADDR(level2_info));
                    for (uint_64 k = 0; k < 512; k++)
                    {
                        uint_64 level3_info = level3_root[k];
                        if (level3_info & PTE_VALID)
                        {
                            debug("|-|-|-Level3 OK|\n");
                            // We should print our info here.
                            uint_64 va = ((uint_64)i << PUD_SHIFT) | ((uint_64)j << PMD_SHIFT) | ((uint_64)k << PTE_SHIFT);
                            uint_64 pa = level3_info;
                            if (limit--)
                                debug("cast from ...0x%016lx to 0x%016lx... %d %d %d\n", va, pa, i, j, k);
                            else
                                return;
                        }
                    }
                }
            }
        }
    }
}

void test_pgdir()
{
    printf("\n---test pgdir---\n");
    printf("Stage 1 - build up a page table");
    uint_64 *pgdir;
    uint_32 *data;
    struct Page *lut_page;
    page_alloc(&lut_page);
    pgdir = (uint_64 *)page2kva(lut_page);
    struct Page *data_page;
    page_alloc(&data_page);
    data = (uint_32 *)page2kva(data_page);

    for (int i = 0; i < 1024; i++)
    {
        data[i] = i; // Fill data into the data page
    }

    // Insert data_page into lut_page
    extern uint_64 *kernel_pud;
    extern uint_64 *user_pud;
    uint_64 *kernel = (uint_64 *)KADDR((uint_64)kernel_pud);
    uint_64 *user = (uint_64 *)KADDR((uint_64)user_pud);
    debug("Kernel pud is %lx , User pud is %lx\n", kernel, user);
    debug("kernel pud value is %lx\n", kernel[0]);
    page_insert(pgdir, data_page, 0x400000, 0);
    // page_insert(pgdir,lut_page,PADDR(pgdir),PTE_ISH | PTE_RO | PTE_AF | PTE_NON_CACHE);
    // page_insert(user,data_page,0x80000,PTE_ISH | PTE_RO | PTE_AF | PTE_NON_CACHE);
    debug_print_pgdir(pgdir);
    set_ttbr0(page2pa(lut_page));
    // set_ttbr0(PADDR(user));
    tlb_invalidate();
    data = (uint_32 *)0x400000;
    debug("data is %d:%d @0x%lx,0x%lx\n", 800, data[800], data, page2pa(data_page));
}