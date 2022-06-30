/*

这个文件中主要实现了设置时间寄存器的值，不知道可不可以改

*/

// TODO: 这里能不能更加自如一些
.global reset_timer
reset_timer:
    mov x0,             #0x3
    msr cntkctl_el1,    x0
    ldr x0,             =(100000)
    //when the qemu start,the frequency is 0x3b9aca0 HZ
    //i don't know why i cannot change the frquency of it
    //doing so to so set 1s per exception
    msr cntp_tval_el0,  x0
    mov x0,             #0x1
    msr cntp_ctl_el0,   x0
    ret