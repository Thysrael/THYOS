#include "sysreg.h"

#define	SCR_VALUE			(SCR_NS | SCR_RW | 0x1b0)
#define HCR_VALUE			(HCR_RW | HCR_SWIO)
#define SPSR_EL3_VALUE		(SPSR_MASK_ALL | SPSR_EL2H)
#define SPSR_EL2_VALUE		(SPSR_MASK_ALL | SPSR_EL1H)
#define SCTLR_VALUE			(SCTLR_D_CACHE | SCTLR_I_CACHE)	

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

// this is the actual _start
_start_master:    
    // 从这里看异常等级，CurrentEL 的 [3:2] 是异常等级
    mrs     X0, 		CurrentEL
	and     X0, 		X0, 		#12 
    // 如果是 EL2 那么就会发生跳转
    cmp     X0, 		#12
    bne     judge_EL2
    // 下面是处理 EL3，但是这种情况一般不会发生
    // 异常处理路由指的是异常发生时应当在哪个异常等级处理，SCR_EL3 和 HCR_EL2 都相当于配置寄存器
    ldr     X2, 		=(SCR_VALUE)
    msr     scr_el3,	X2
    ldr     X2, 		=(SPSR_EL3_VALUE)
    msr     spsr_el3, 	X2
    adr     x2, 		judge_EL2
    msr     elr_el3, 	X2
    eret


judge_EL2:  
	// 如果是 EL1 就会发生跳转
    cmp     X0, 		#4
    beq     clear_bss
	// TODO 这里顺序
	adr     X1, 		_start
	msr     sp_el1, 	X1
    
    // 底下的寄存器在普通手册里没有，但在专有手册中有，也是设置，似乎不用看
	// disable coprocessor traps
    mov     X0,         #0x33FF
    msr     cptr_el2,   X0          //essential! give access to SIMD, see reference 1891
    msr     hstr_el2,   xzr         //seems not so useful. reference P1931
    mov     X0,         #0xf<<20    //essential! give access to SIMD,see reference 3808
    msr     cpacr_el1,  X0

    // 设置 HCR
    ldr 	X0,			=(HCR_VALUE)
    msr     hcr_el2, 	X0
    // 设置 SCTLR，但是此时没有开启 MMU
    ldr		X0,			=(SCTLR_VALUE)
    msr     sctlr_el1, 	X0
    
    ldr     X0, 		=(SPSR_EL2_VALUE)
    msr     spsr_el2, 	X0
    adr     X0, 		clear_bss
    msr     elr_el2, 	X0
    eret

clear_bss:
    adr     X1, 		__bss_start
    ldr     W2, 		=__bss_size
clear_loop:
	cbz     W2, 		en_mmu
    str     xzr, 		[X1], 			#8
    sub     W2, 		W2, 			#1
    cbnz    W2, 		clear_loop

en_mmu:
    msr 	spsel,		#1
    adr     X0, 		init_page_table
    blr     X0
    adr     X0, 		enable_mmu
    blr     X0
	// 这就是重定向
    ldr     X0, 		=jump_main
    br      X0

jump_main:  
	// TODO 重新设置栈指针
    ldr 	X0, 		=(kernel_sp)
    mov 	sp, 		X0
    bl 		main
    b 		pro_hang
