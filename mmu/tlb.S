// 这里是清空 tlb 的所有表项
.globl tlb_invalidate
tlb_invalidate:
    dsb     ishst               // ensure write has completed
    // tlbi    vmalls12e1is       // invalidate tlb, all asid, el1.
    tlbi    vmalle1is
    dsb     ish                 // ensure completion of tlb invalidation
    isb                         // synchronize context and ensure that no instructions
                                // are fetched using the old translation
    ret