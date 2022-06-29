/*

这个文件主要是为了初始化页表。

*/

#include "types.h"
#include "mmu.h"
#include "printf.h"

// freemem 是物理地址的游标
uint_64 freemem;
uint_64 *kernel_pud;
uint_64 *user_pud;

void init_page_table()
{
    uint_64 *pud, *pmd, *pmd_entry, *pte, *pte_entry;
    uint_64 i, r, t;

    if (freemem == 0)
    {
        freemem = (uint_64)_end;
        freemem = ROUND(freemem, BY2PG);
    }
    // 分配第一级页表
    pud = (uint_64 *)freemem;
    freemem += BY2PG;
    // 在第一级页表上登记上 _end 对应的这一项，需要 user 的原因是可能暴露内核的时候需要
    pud[PUDX(pud)] = (freemem | PTE_VALID | PTE_TABLE | PTE_AF | PTE_USER | PTE_ISH | PTE_NORMAL);
    // 分配第二级页表
    pmd = (uint_64 *)freemem;
    freemem += BY2PG;

    // 我们在外循环填写第二级页表项
    int n_pmd_entry = PHY_TOP >> PMD_SHIFT;
    for (r = 0; r < n_pmd_entry; r++)
    {
        // 填写二级页表项
        pmd_entry = pmd + r;
        // 暴露内核的时候可能需要设置为 PTE_USER
        *pmd_entry = (freemem | PTE_VALID | PTE_TABLE | PTE_AF | PTE_USER | PTE_ISH | PTE_NORMAL);

        // 分配第三级页表
        pte = (uint_64 *)freemem;
        freemem += BY2PG;
        for (t = 0; t < 512; t++)
        {
            pte_entry = pte + t;
            // 填写三级页表项
            i = (r << 21) + (t << 12);
            // 这里确实只有当设置成 ReadOnly 的时候能跑起来，我不知道为啥
            // 这个 if 里的是内核的程序段，这么看似乎用户进程可能也有这个问题
            if (i >= 0x80000 && i < (uint_64)(_data))
            {
                (*pte_entry) = i | PTE_VALID | PTE_TABLE | PTE_AF | PTE_NORMAL | PTE_USER | PTE_RO;
            }
            else
            {
                (*pte_entry) = i | PTE_VALID | PTE_TABLE | PTE_AF | PTE_NORMAL | PTE_USER;
            }
        }
    }

    // 将这个二级页表填完
    for (r = n_pmd_entry; r < 512; r++)
    {
        pmd[r] = ((r << 21) | PTE_VALID | PTE_AF | PTE_USER | PTE_NORMAL);
    }

    // 这里是 MMIO 的一种表现形式
    pud[PUDX(0x40000000)] = (freemem | PTE_VALID | PTE_TABLE | PTE_AF | PTE_USER | PTE_ISH | PTE_NORMAL);
    // 又分配了一个二级页表
    pmd = (uint_64 *)freemem;
    freemem += BY2PG;
    pmd[0] = (0x40000000 | PTE_VALID | PTE_AF | PTE_USER | PTE_DEVICE);
    kernel_pud = pud;
    user_pud = pud;
    return;
}