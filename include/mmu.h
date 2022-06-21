#ifndef _MMU_H_
#define _MMU_H_

#define BY2PG 4096
// 这是一个第一级页表项对应的大小
#define PUDMAP (0x40000000)

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
#define KERNEL_BASE             0xffffff8000000000
#define KERNEL_INIT_STACK_BASE  0xffffff8000800000
#define TIMESTACK               0xffffff8002000000
#define KERNEL_SP               0xffffff8001ffd000

#define UVPT                    0x0000004000000000
#define UVMD                    (UVPT + (UVPT >> 9))
#define UVUD                    (UVMD + (UVPT >> 18))
#define UPAGES                  (UVPT - PUDMAP)
#define UENVS                   (UPAGES - PUDMAP)
#define UTOP                    (UENVS)
#define UXSTACKTOP              (UTOP)
#define USTACKTOP               (UXSTACKTOP - 2 * BY2PG)


/*================== 物理内存 =======================*/
// 这是物理内存的可用上限，剩下的需要留给外设
#define PHY_TOP                 0x3f000000
// 这是物理内存的容量，一个第一级页表项对应的虚拟地址空间刚好是物理地址空间的大小
#define PHY_LIM					0x40000000

/*================== 地址转换 =======================*/

extern uint_64 npage;
#define PPN(pa) (((uint_64)(pa)) >> PTE_SHIFT)
#define VPN(va) PPN(va)
#define PTE_ADDR(pte) ((uint_64)(pte) & ~0xffffff8000000fff)
#define VA2PFN(va) (((uint_64)(va)) & 0xFFFFF000)

#define PADDR(kva)                                           \
	({                                                       \
		uint_64 a = (uint_64)(kva);                          \
		if (a < KERNEL_BASE)                                 \
			panic("PADDR called with invalid kva %08lx", a); \
		a - KERNEL_BASE;                                     \
	})

// translates from physical address to kernel virtual address
#define KADDR(pa)                                                    \
	({                                                               \
		uint_64 ppn = PPN(pa);                                       \
		uint_64 ppa = pa;											 \
		if (ppn >= npage)                                            \
			panic("KADDR called with invalid pa %08lx", (u_long)pa); \
		(ppa) + KERNEL_BASE;                                          \
	})

#define assert(x)                              \
	do                                         \
	{                                          \
		if (!(x))                              \
			panic("assertion failed: %s", #x); \
	} while (0)

/*================== 错误码 =======================*/
#define E_UNSPECIFIED 	1	 		// Unspecified or unknown problem
#define E_BAD_ENV 		2		 	// Environment doesn't exist or otherwise
						 			// cannot be used in requested action
#define E_INVAL 		3		 	// Invalid parameter
#define E_NO_MEM 		4		 	// Request failed due to memory shortage
#define E_NO_FREE_ENV 	5	 		// Attempt to create a new environment beyond
						 			// the maximum allowed
#define E_IPC_NOT_RECV 	6 			// Attempt to send to env that is not recving.

// File system error codes -- only seen in user-level
#define E_NO_DISK 		7		 	// No free space left on disk
#define E_MAX_OPEN 		8	 		// Too many files are open
#define E_NOT_FOUND 	9	 		// File or block not found
#define E_BAD_PATH 		10	 		// Bad path
#define E_FILE_EXISTS 	11 			// File already exists
#define E_NOT_EXEC 		12	 		// File not a valid executable

void init_page_table();


#endif