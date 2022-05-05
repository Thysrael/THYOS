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

void mips_detect_memory();
void boot_map_segment(uint_64 *pud, uint_64 va, uint_64 size, uint_64 pa, uint_64 perm);
void arch_basic_init();
void page_init();

#endif /* _PMAP_H_ */