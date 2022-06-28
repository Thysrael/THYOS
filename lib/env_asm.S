/* 

这个文件主要用于实现 env_pop_tf。

*/

.global env_pop_tf
// x0 中存的是 env_tf 的地址，x1 存的是一级页表
env_pop_tf:
    // 这里开始恢复寄存器环境, x16 是基地址，我不知道他为啥选择这个
    mov x16,        x0
    // 剩下了 x16 和 x17 没有恢复，似乎起得作用与 k0 和 k1 类似
	ldp	x0, x1,     [x16, #16 * 0]
	ldp	x2, x3,     [x16, #16 * 1]
	ldp	x4, x5,     [x16, #16 * 2]
	ldp	x6, x7,     [x16, #16 * 3]
	ldp	x8, x9,     [x16, #16 * 4]
	ldp	x10, x11,   [x16, #16 * 5]
	ldp	x12, x13,   [x16, #16 * 6]
	ldp	x14, x15,   [x16, #16 * 7]
	ldp	x18, x19,   [x16, #16 * 9]
	ldp	x20, x21,   [x16, #16 * 10]
	ldp	x22, x23,   [x16, #16 * 11]
	ldp	x24, x25,   [x16, #16 * 12]
	ldp	x26, x27,   [x16, #16 * 13]
	ldp	x28, x29,   [x16, #16 * 14]
	ldr	x30,        [x16, #16 * 15] 
	// 恢复栈指针
	ldr x17,        [x16, #8 * 31]
	msr sp_el0,     x17
    // 恢复 elr
	ldr x17,        [x16, #8 * 32]
	msr elr_el1,    x17
    // 恢复 spsr
	ldr x17,        [x16, #8 * 33]
	msr spsr_el1,   x17
	// ldr x17,        [x16, #8 * 32]
	// br  x17
	// 到最后也没有恢复 x16 和 x17，好像也没必要恢复 far 和 esr
	eret


.global set_ttbr0
set_ttbr0:
	msr ttbr0_el1, x0

	tlbi vmalle1is
  	//dsb ish              // ensure completion of TLB invalidation
    dsb sy
	isb
    nop
    nop
    nop
    nop
    nop
    nop
	ret