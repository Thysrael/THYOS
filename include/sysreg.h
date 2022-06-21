/*********************** SCR ***********************/
// SCR 是异常等级为 3 的时候的配置寄存器
// 在白书 P144 有讲，但是不全

// 这位与安全内存有关，但是我不知道啥意思
#define SCR_NS              1
// 这位置 1 说明是 Arch64 而置 0 说明是 Arch32
#define SCR_RW              (1 << 10)


/*********************** HCR ***********************/
// HCR 是异常等级为 2 的时候的配置寄存器
// 在白书 P144 有讲，但不全

#define HCR_RW              (1 << 31)
// SWIO hardwired on Pi3, 我不知达到哦啥意思
#define HCR_SWIO            (1 << 1)


/*********************** SPSR ***********************/
// Saved Process Status Register
// SPSR 主要用来保存发生异常时的 PSTATE 寄存器，在白书 P154，或者普通手册 4.1.5

// 对应 [9:6] DAIF 意思是关闭中断
#define SPSR_MASK_ALL       (15 << 6)
// 对应 [3:0] 设置异常返回哪一个等级，我不知道具体的对应规则
#define SPSR_EL2H           (9 << 0)
#define SPSR_EL1H           (4 << 0)


/*********************** SCTLR ***********************/
// system control register 系统控制寄存器，在指导书有详细配置
// 我还没有设置的很全面，是很紧缩的设置

// 开启MMU
#define SCTLR_MMU_EN        (1 << 0)
// 开启数据 Cache
#define SCTLR_D_CACHE       (1 << 2)
// 开启指令 Cache
#define SCTLR_I_CACHE       (1 << 12)


/*********************** TCR ***********************/
// Translation Control Register 翻译控制寄存器，用于控制 TLB 的行为
// 在指导书上有详细配置


// 看指导书
#define TCR_IGNORE1         (1 << 38)
#define TCR_IGNORE0         (1 << 37)
// TG1 的页面是 4K
#define TCR_TG1_4K          (0 << 30)
// 内部共享 TTBR1_EL1
#define TCR_ISH1            (3 << 28)
// TTBR1_EL1 外写通达可缓存
#define TCR_OWT1            (2 << 26)
// TTBR1_EL1 内写通达可缓存
#define TCR_IWT1            (2 << 24)
// 25 位掩码
#define TCR_T0SZ            (25)
#define TCR_T1SZ            (25 << 16)
// TG2 的页面是 4K
#define TCR_TG0_4K          (0 << 14)
// 内部共享 TTBR0_EL1
#define TCR_ISH0            (3 << 12)
// TTBR0_EL1 外写通达可缓存
#define TCR_OWT0            (2 << 10)
// TTBR0_EL1 内写通达可缓存
#define TCR_IWT0            (2 << 8)