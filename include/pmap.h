#ifndef _PMAP_H_
#define _PMAP_H_

#include "types.h"
#include "queue.h"
#include "mmu.h"
#include "printf.h"

LIST_HEAD(Page_list, Page);
typedef LIST_ENTRY(Page) Page_LIST_entry_t;

struct Page
{
    Page_LIST_entry_t pp_link; 
    u_short pp_ref;
};

extern struct Page *pages;
extern void tlb_invalidate();

static inline uint_64 page2ppn(struct Page *pp)
{
    return pp - pages;
}

static inline uint_64 page2pa(struct Page *pp)
{
    return page2ppn(pp) << PTE_SHIFT;
}

static inline struct Page * pa2page(u_long pa)
{
    if (PPN(pa) >= npage)
        panic("pa2page called with invalid pa: %x", pa);
    return &pages[PPN(pa)];
}

static inline u_long page2kva(struct Page *pp)
{
    return KADDR(page2pa(pp));
}

static inline u_long va2pa(uint_64 *pud, uint_64 va)
{
    uint_64 *pud_entry, *pmd, *pmd_entry, *pt, *pt_entry;
    pud_entry = pud + PUDX(va);
    if (!(*pud_entry & PTE_VALID))
    {
        return ~0;
    }

    pmd = (uint_64 *)KADDR(PTE_ADDR(*pud_entry));
    pmd_entry = pmd + PMDX(va);
    if (!(*pmd_entry & PTE_VALID))
    {
        return ~0;
    }

    pt = (uint_64 *)KADDR(PTE_ADDR(*pmd_entry));
    pt_entry = pt + PTEX(va);
    if (!(*pt_entry & PTE_VALID))
    {
        return ~0;
    }
    return PTE_ADDR(*pt_entry);
}

void mips_detect_memory();
void boot_map_segment(uint_64 *pud, uint_64 va, uint_64 size, uint_64 pa, uint_64 perm);
void arch_basic_init();
void page_init();
int page_alloc(struct Page **pp);
void page_free(struct Page *pp);
int pgdir_walk(uint_64 *pud, uint_64 va, int create, uint_64 **ppte);
int page_insert(uint_64 *pud, struct Page *pp, uint_64 va, uint_64 perm);
struct Page *page_lookup(uint_64 *pud, uint_64 va, uint_64 **ppte);
void page_decref(struct Page *pp);
void page_remove(uint_64 *pud, uint_64 va);
void pageout(uint_64 va, uint_64 *context);

#endif /* _PMAP_H_ */