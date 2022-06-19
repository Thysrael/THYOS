/*

这个文件里主要定义了 Trapframe 结构体。

这个结构体他里保存了五个特殊寄存器：
    sp：        栈指针
    elf：       异常返回地址
    pstate：    状态寄存器
    far：       错误地址
    esr：       同步异常的错误原因寄存器

*/

#ifndef _TRAP_H_
#define _TRAP_H_

#include "types.h"

struct Trapframe
{
    uint_64 x[31];
    uint_64 sp;
    uint_64 elr;
    uint_64 pstate;
    uint_64 far;
    uint_64 esr;
};

/*
 * Size of stack frame, word/double word alignment
 */
#define TF_SIZE         288

#endif /* _TRAP_H_ */