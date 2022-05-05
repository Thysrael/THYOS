#define TCR_T0SZ			(25) 
#define TCR_T1SZ			((25) << 16)
#define TCR_TG0_4K			(0 << 14)
#define TCR_TG1_4K			(0 << 30)
#define TCR_VALUE			(TCR_T0SZ | TCR_T1SZ | TCR_TG0_4K | TCR_TG1_4K|(0b00110101LL << 8)|(0b00110101LL << 24))

.global enable_mmu
enable_mmu:
    adrp	x0, _pg_dir				
	msr	ttbr0_el1, x0			
	msr	ttbr1_el1, x0

    ldr x0, =0x440488
    msr mair_el1,x0
    //msr mair_el0,x0

    ldr	x0, =(TCR_VALUE)		
	msr	tcr_el1, x0

    mrs x0,sctlr_el1
    orr x0,x0,#0x1
    msr sctlr_el1,x0
    
    ret