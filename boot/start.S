// declare the function symbol
.global _start

.section ".text.boot"

_start:
	// X1 will store the ID of processor, different processor has different ID
    mrs     X1,			MPIDR_EL1			
	and		X1,			X1,			#3
	// Only the processor who has the ID equals 0 can jump to the _start_master, others will wait
	cbz		X1,			_start_master

pro_hang:
	// wfe is instruction just like nop, wfe = wait for event
	wfe
	// a tradtional endless loop, use to hang the pro
	b		pro_hang

// this is the actual _start,
_start_master:
    // set top of stack just before our code (stack grows to a lower address per AAPCS64)
    ldr     X1,			=_start
	// get the exception level
    mrs     X0, 		CurrentEL
	and     X0, 		X0, 		#12 // clear reserved bits
	// running at EL3?
    cmp     X0, 		#12
    bne     judge_EL2
    // should never be executed, just for completeness
	// I don't know the meaning, I just copy the god 
    mov     X2, 		#0x5b1
    msr     scr_el3,	X2
    mov     X2, 		#0x3c9
    msr     spsr_el3,	X2
    adr     X2, 		judge_EL2
    msr     elr_el3,	X2
    eret

judge_EL2:
	// running at EL1?
	cmp     X0, 		#4
    beq     clear_bss
	// set the stack top at EL1
    msr     sp_el1, 	X1

    // disable coprocessor traps
    mov     X0,         #0x33FF
    msr     cptr_el2,   X0          //essential! give access to SIMD, see reference 1891
    msr     hstr_el2,   xzr         //seems not so useful. reference P1931
    mov     X0,         #0xf<<20    //essential! give access to SIMD,see reference 3808
    msr     cpacr_el1,  X0

    // enable AArch64 in EL1
    mov     X0,         #1<<31                  // set to AArch64
    orr     X0,         X0,         #1<<1       // SWIO hardwired on Pi3,Reference 1928 ???
    msr     hcr_el2,    X0
    mrs     X0,         hcr_el2
    // Setup SCTLR access
    mov     X2,         #0x0800
    movk    X2,         #0x30d0,    lsl     #16 //MOVK :move with keep
    msr     sctlr_el1,  X2


	// change execution level to EL1
    mov     X2, 		#4
    msr     spsr_el2, 	X2
    adr     X2, 		clear_bss
    msr     elr_el2, 	X2
    eret

clear_bss:
    ldr     X1, 		=__bss_start
    ldr     W2, 		=__bss_size
	clear_loop:  
		cbz     W2, 		jump_main
    	str     XZR, 		[X1], 		#8
    	sub     W2, 		W2, 		#1
    	cbnz    W2, 		clear_loop

jump_main:
    msr 	spsel,		#1
    bl 		main
    b 		pro_hang
