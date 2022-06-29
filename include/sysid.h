/*

这个文件里是系统调用号的定义。

有考虑过将系统调用号的定义放到 syscall.h 这个文件中，但是那样会对用户暴露系统调用函数。
所以最终放到了这个文件中。

*/

#ifndef _SYSID_H_
#define _SYSID_H_

#define SYS_putchar                 1
#define SYS_getenvid                2
#define SYS_yield                   3
#define SYS_env_destroy             4
#define SYS_set_pgfault_handler     5
#define SYS_mem_alloc               6
#define SYS_mem_map                 7
#define SYS_mem_unmap               8
#define SYS_env_alloc               9
#define SYS_set_env_status          10
#define SYS_set_trapframe           11
#define SYS_panic                   12
#define SYS_ipc_can_send            13
#define SYS_ipc_recv                14
#define SYS_cgetc                   15
#define SYS_write_sd                16
#define SYS_read_sd                 17

#endif