/*

这个文件可以看作是 MOS 中 genex.S trap.c 两个文件的并集。

在这个文件里会构造基本的异常处理函数的模板。同时还有异常向量表的构造。

*/


#include "entry.h"

// 基本上 handler 就是只要跳到对应的函数处就好了
.macro handler label
    .align 7
    b       \label
.endm

// 异常向量表，只有中间两段需要构造
.align 11
.global vectors
vectors:
    handler	sync_invalid_el1t			// Synchronous EL1t
	handler	irq_invalid_el1t			// IRQ EL1t
	handler	fiq_invalid_el1t			// FIQ EL1t
	handler	error_invalid_el1t			// Error EL1t

    // EL1 异常陷入 EL1 处理
	handler	el1_sync			        // Synchronous EL1h
	handler	el1_irq					    // IRQ EL1h
	handler	fiq_invalid_el1h			// FIQ EL1h
	handler	error_invalid_el1h			// Error EL1h

    // EL0 异常陷入 EL1 处理
	handler	el0_sync		            // Synchronous 64-bit EL0
	handler	el0_irq			            // IRQ 64-bit EL0
	handler	fiq_invalid_el0_64			// FIQ 64-bit EL0
	handler	error_invalid_el0_64	    // Error 64-bit EL0

	handler	sync_invalid_el0_32			// Synchronous 32-bit EL0
	handler	irq_invalid_el0_32			// IRQ 32-bit EL0
	handler	fiq_invalid_el0_32			// FIQ 32-bit EL0
	handler	error_invalid_el0_32		// Error 32-bit EL0



// daif 是 PSTATE 中的标志位，这里把 I 设置成 1
.macro CLI
    msr daifset,    #2 // close interrupt
.endm

.macro STI
    msr daifclr,    #2 // open interrupt
.endm

// stp 是同时存储两个寄存器值的意思，store pair 
.macro SAVE_ALL
    sub	sp, sp,     #TF_SIZE

	stp	x0, x1,     [sp, #16 * 0]
	stp	x2, x3,     [sp, #16 * 1]
	stp	x4, x5,     [sp, #16 * 2]
	stp	x6, x7,     [sp, #16 * 3]
	stp	x8, x9,     [sp, #16 * 4]
	stp	x10, x11,   [sp, #16 * 5]
	stp	x12, x13,   [sp, #16 * 6]
	stp	x14, x15,   [sp, #16 * 7]
	stp	x16, x17,   [sp, #16 * 8]
	stp	x18, x19,   [sp, #16 * 9]
	stp	x20, x21,   [sp, #16 * 10]
	stp	x22, x23,   [sp, #16 * 11]
	stp	x24, x25,   [sp, #16 * 12]
	stp	x26, x27,   [sp, #16 * 13]
	stp	x28, x29,   [sp, #16 * 14]

    // store the LR
	str	x30,        [sp, #8 * 30]
    // store the SP
	mrs x16,        sp_el0
	str x16,        [sp, #8 * 31]
    // store the ELR
	mrs x16,        elr_el1
	str x16,        [sp, #8 * 32]
    // store the PSTATE
	mrs x16,        spsr_el1
	str x16,        [sp, #8 * 33]
    // store the FAR
    mrs x16,        far_el1
    str x16,        [sp, #8 * 34]
    // store the ESR
    mrs x16,        esr_el1
    str x16,        [sp, #8 * 35]
.endm

.macro RESTORE
    ldp	x0, x1,     [sp, #16 * 0]
	ldp	x2, x3,     [sp, #16 * 1]
	ldp	x4, x5,     [sp, #16 * 2]
	ldp	x6, x7,     [sp, #16 * 3]
	ldp	x8, x9,     [sp, #16 * 4]
	ldp	x10, x11,   [sp, #16 * 5]
	ldp	x12, x13,   [sp, #16 * 6]
	ldp	x14, x15,   [sp, #16 * 7]
	ldp	x16, x17,   [sp, #16 * 8]
	ldp	x18, x19,   [sp, #16 * 9]
	ldp	x20, x21,   [sp, #16 * 10]
	ldp	x22, x23,   [sp, #16 * 11]
	ldp	x24, x25,   [sp, #16 * 12]
	ldp	x26, x27,   [sp, #16 * 13]
	ldp	x28, x29,   [sp, #16 * 14]

    // restore LR
	ldr	x30,        [sp, #8 * 30]
    // restore SP，这里应该没有问题，因为恢复的是 sp_el0，而现在用的是 sp_el1
	ldr x16,        [sp, #8 * 31]
	msr sp_el0,     x16
    // restore ELR
	ldr x16,        [sp, #8 * 32]
	msr elr_el1,    x16
    // restore PSTATE
	ldr x16,        [sp, #8 * 33]
	msr spsr_el1,   x16
    // 这里似乎没有必要恢复这俩寄存器
    // restore FAR
    // ldr x16,        [sp, #8 * 34]
    // msr far_el1,    x16
    // restore ESR
    // ldr x16,        [sp, #8 * 35]
    // msr esr_el1     x16
	add	sp, sp,     #TF_SIZE		
.endm

// 这是所有没有实现的异常处理函数，主要负责打印一下异常信息
.macro unimplement_entry type
    CLI
    SAVE_ALL
    mov x0,     #\type
    mrs x1,     esr_el1
    mrs x2,     elr_el1
    bl unimplement_handler
.endm

// 这些都是不需要实现的异常处理函数
sync_invalid_el1t:
	unimplement_entry  SYNC_INVALID_EL1t

irq_invalid_el1t:
	unimplement_entry  IRQ_INVALID_EL1t

fiq_invalid_el1t:
	unimplement_entry  FIQ_INVALID_EL1t

error_invalid_el1t:
	unimplement_entry  ERROR_INVALID_EL1t

//sync_invalid_el1h:
	//unimplement_entry  SYNC_INVALID_EL1h

fiq_invalid_el1h:
	unimplement_entry  FIQ_INVALID_EL1h

error_invalid_el1h:
	unimplement_entry  ERROR_INVALID_EL1h

sync_invalid_el0_64:
	unimplement_entry  SYNC_INVALID_EL0_64


fiq_invalid_el0_64:
	unimplement_entry  FIQ_INVALID_EL0_64

error_invalid_el0_64:
	unimplement_entry  ERROR_INVALID_EL0_64

sync_invalid_el0_32:
	unimplement_entry  SYNC_INVALID_EL0_32

irq_invalid_el0_32:
	unimplement_entry  IRQ_INVALID_EL0_32

fiq_invalid_el0_32:
	unimplement_entry  FIQ_INVALID_EL0_32

error_invalid_el0_32:
	unimplement_entry  ERROR_INVALID_EL0_32


// 处理时钟中断
el1_irq:
el0_irq:
    // CLI
	ldr     x16,    =(TIMESTACK)
	mov     sp,     x16
    SAVE_ALL
	
	bl      handle_irq

	RESTORE
	eret 

// 处理缺页异常和系统调用
el1_sync:
el0_sync:
	// CLI
	ldr     x16,    =(KERNEL_SP)
	mov     sp,     x16
	SAVE_ALL

    // 这里传入了三个参数，一个是是上下文指针，还有两个是页表
    mov    x0,     sp
    mrs    x1,     ttbr0_el1
    mrs    x2,     ttbr1_el1
    bl     handle_sync

	RESTORE
	eret 


// 这个函数用于给 VBAR 赋值，使其可以查表
.globl irq_vector_init
irq_vector_init:
	ldr	x0,         =vectors		// load VBAR_EL1 with virtual
	msr	vbar_el1,   x0		        // vector table address
	ret