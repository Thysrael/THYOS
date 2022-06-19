/* 

这个文件里有两个函数，一个是起始函数 start, 一个是用户态读写异常处理函数。

读写异常处理函数主要用于跳转到真正的处理函数处，和恢复现场。

恢复现场是在用户态进行的，所以对于 sp 的恢复和 elr 要特殊处理

*/

.section ".text.boot"
.globl _start

_start:
	ldr	    x0,     [sp, #16 * 0]
	ldr	    x1,     [sp, #16 * 1]

	bl	libmain

.section ".text"
.extern __pgfault_handler
.global __asm_pgfault_handler
__asm_pgfault_handler:
	ldr	    x0,     [sp, #8 * 34]
	ldr	    x16,    __pgfault_handler
	blr     x16	

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
    // 似乎也没有必要恢复这俩寄存器，因为现在是 EL0
    // restore ELR
	// ldr x16,        [sp, #8 * 32]
	// msr elr_el1,    x16
    // restore PSTATE
	// ldr x16,        [sp, #8 * 33]
	// msr spsr_el1,   x16
    // 这里似乎没有必要恢复这俩寄存器
    // restore FAR
    // ldr x16,        [sp, #8 * 34]
    // msr far_el1,    x16
    // restore ESR
    // ldr x16,        [sp, #8 * 35]
    // msr esr_el1     x16
    // 首先保存 elr
    ldr x17,        [sp, #8 * 33]
	// restore SP，因为在用户态，所以使用的都是 sp_el0, 因此需要最后恢复
	ldr x16,        [sp, #8 * 31]
	msr sp_el0,     x16
    // 跳转到 x17
    br  x17