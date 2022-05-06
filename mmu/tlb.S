.globl tlb_invalidate
tlb_invalidate:
    dsb     ishst               // ensure write has completed
    tlbi    vmalle1is           // invalidate tlb, all asid, el1.
    dsb     ish                 // ensure completion of tlb invalidation
    isb                         // synchronize context and ensure that no instructions
                                // are fetched using the old translation
    ret