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
	// 如果是 EL3 那么就会发生跳转
    cmp     X0, 		#12
    bne     judge_EL2
    // should never be executed, just for completeness
	// The SCR_EL3 register specifies which exceptions are to be routed to EL3
    // HCR_EL2 specifies which exceptions are to be routed to EL2
    // 异常处理路由指的是异常发生时应当在哪个异常等级处理，SCR_EL3 和 HCR_EL2 都相当于配置文件
    // 0x5b1 = 0101_1100_0001
    // 具体的配置在 白书P144 页有讲，但是不全
    mov     X2, 		#0x5b1
    msr     scr_el3,	X2
    // SPSR 主要用来保存发生异常时的 PSTATE 寄存器，其中 SPSR.M[3:0] 记录着返回哪一个异常等级
    // 发生异常的时候，CPU 会把 PSTATE 寄存器中的值保存到对应目标异常等级的 SPSR_ELx 中
    // 把异常原因写到 ESR_ELx 寄存器中
    // 切换 SP 寄存器为目标异常等级的 SP_ELx 或者 SP_EL0 寄存器 
    // 0x3c9 = 0011_1100_1001
    // SPSR_MASK_ALL (7 << 6) 的意思是关闭系统的 DAIF（调试，系统错误，IRQ,FIQ）
    // SPSR_EL2h (9 << 0) 的意思是异常返回的等级是 EL2
    // 这样基本上所有的就都解释通了
    // 在 白书 P154 
    // 但是手册上有不同记载 SPSR[9:6] 是 DAIF, 低 4 位记录着返回哪一个异常等级，但是没记录对应关系
    // 在手册 4.1.5，有完整的 SPSR 的位图
    mov     X2, 		#0x3c9
    msr     spsr_el3,	X2
    adr     X2, 		judge_EL2
    msr     elr_el3,	X2
    eret

judge_EL2:
	// 如果是 EL1 那么就跳转清零就可以了
	cmp     X0, 		#4
    beq     clear_bss
	// set the stack top at EL1
    msr     sp_el1, 	X1

    // disable coprocessor traps
    // 底下的寄存器在普通手册里没有，但在专有手册中有，也是设置，似乎不用看
    mov     X0,         #0x33FF
    msr     cptr_el2,   X0          //essential! give access to SIMD, see reference 1891
    msr     hstr_el2,   xzr         //seems not so useful. reference P1931
    mov     X0,         #0xf<<20    //essential! give access to SIMD,see reference 3808
    msr     cpacr_el1,  X0

    // enable AArch64 in EL1
    // 这个在上面讲了
    mov     X0,         #1<<31                  // set to AArch64
    orr     X0,         X0,         #1<<1       // SWIO hardwired on Pi3,Reference 1928 ???
    msr     hcr_el2,    X0
    mrs     X0,         hcr_el2

    // SCTLR 是系统控制寄存器
    // Controls architectural features, for example the MMU, caches and alignment checking.
    // 在普通手册的 4.3.1 会讲，但是我没看懂
    // Setup SCTLR access
    mov     X2,         #0x0800
    movk    X2,         #0x30d0,    lsl     #16 //MOVK :move with keep
    msr     sctlr_el1,  X2

	// change execution level to EL1
    // 我不知道这里为啥是 4,白书中说是 5
    // 而且这样的话，似乎 DAIF 都没有关
    // 我把 X2 的值由 4 改为了 0x3c5, 这样就是完全按照白书 P154 的配置了
    mov     X2, 		#0x3c5
    msr     spsr_el2, 	X2
    // elr 是异常返回的地址寄存器，为啥不直接跳转
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
