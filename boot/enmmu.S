/* 

这个文件中的函数实现了开启 MMU。

主要是将两个页表移入到了 ttbr 中，设置了 TCR 和 SCTLR 寄存器

*/

#include "sysreg.h"

#define TCR_VALUE   (TCR_T0SZ | TCR_T1SZ | TCR_TG0_4K | TCR_TG1_4K | TCR_IGNORE1 | TCR_IGNORE0 | TCR_ISH1 | TCR_ISH0 | TCR_OWT | TCR_IWT)
#define MAIR_VALUE  (0x440488)

.global enable_mmu
enable_mmu:
    adrp	x0,             _pg_dir				
	msr	    ttbr0_el1,      x0			
	msr	    ttbr1_el1,      x0

    ldr     x0,             =(MAIR_VALUE)
    msr     mair_el1,       x0


    ldr	    x0,             =(TCR_VALUE)		
	msr	    tcr_el1,        x0

    mrs     x0,             sctlr_el1
    orr     x0,             x0,             #0x1
    msr     sctlr_el1,      x0
    
    ret