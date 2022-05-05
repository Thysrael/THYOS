#ifndef _MMU_H_
#define _MMU_H_

#define BY2PG 4096

/*======================= 读取页表 ==========================*/
#define	PUD_SHIFT   30
#define PUDX(va) 	((((unsigned long)(va)) >> PUD_SHIFT) & 0x1ff)

#define	PMD_SHIFT	21
#define PMDX(va) 	((((unsigned long)(va)) >> PMD_SHIFT) & 0x1ff)

#define PTE_SHIFT	12
#define PTEX(va) 	((((unsigned long)(va)) >> PTE_SHIFT) & 0x1ff)

/*================== 页表标志位 =======================*/
// 这位表示页表项或者页目录项是否有效
#define PTE_VALID           1
// 这位表示该项是页目录项，则置1,是页表项，则置0
#define PTE_TABLE           (1 << 1)
// 这是 Atrribute Index
#define PTE_NORMAL 			(0 << 2)
#define PTE_DEVICE 			(1 << 2)
#define PTE_NON_CACHE 		(2 << 2)
// 此为访问权限设置 AP
// 仅 EL1 + 访问
#define PTE_KERN            (0 << 6)
// EL0 + 可访问
#define PTE_USER            (1 << 6)
// 读写
#define PTE_RW              (0 << 7)
// 只读
#define PTE_RO              (1 << 7)
// 此为共享性和缓存性设置 SH
// 外部共享(核心 Cluster 间)需要给设备内存标记
#define PTE_OSH             (2 << 8)
// 内部共享(Cluster 内)需要给普通内存标记
#define PTE_ISH             (3 << 8)
// AF (Access Flag) 标志位
#define PTE_AF 				(1 << 10)
// 不可执行标记 (PrivilegedExecute-Never)
#define PTE_PXN 			(1UL << 53)
// EL0 不可执行标记 (Unprivileged Execute-Never)
#define PTE_UXN 			(1UL << 54)

/* Rounding; only works for n = power of two */
#define ROUND(a, n) (((((unsigned long)(a)) + (n)-1)) & ~((n)-1))
#define ROUNDDOWN(a, n) (((unsigned long)(a)) & ~((n)-1))

/*================== 虚拟内存 =======================*/
// end 是所有段都结束的标志，我们在这个位置开始放置页表
extern char _end[];
extern char _data[];
#define KERNEL_BASE        0xffffff8000000000

/*================== 物理内存 =======================*/
// 这是物理内存的可用上限，剩下的需要留给外设
#define PHY_TOP              0x3f000000


void init_page_table();

#endif