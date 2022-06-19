/* 

这个文件里有异常调用函数。

*/

.global msyscall
msyscall:
    svc     #0
    ret