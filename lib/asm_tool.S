/*

这个文件中主要是一些难以分类，而且工具性较强的汇编函数。

*/

// 这个函数是为了显示当前的异常等级
.global get_EL
get_EL:
    mrs     x0,     CurrentEl
    lsr     x0,     x0,         #2
    ret

.globl put32
put32:
	str w1,[x0]
	ret

.globl get32
get32:
	ldr w0,[x0]
	ret