// 这个函数是为了显示当前的异常等级
.global get_EL

get_EL:
    mrs     x0,     CurrentEl
    lsr     x0,     x0,         #2
    ret