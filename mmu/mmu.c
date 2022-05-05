#include "types.h"
#include "mmu.h"
#include "printf.h"

// freemem 是物理地址的游标
uint_64 freemem;

void init_page_table()
{
    uint_64 *pud, *pmd, *pmd_entry, *pte, *pte_entry;
    uint_64 i, r, t;
    printf("end is %lx\n", _end);
    freemem = (int)_end;
    freemem = ROUND(freemem, BY2PG);

    // 分配第一级页表
    pud = (uint_64 *)freemem; 
    freemem += BY2PG;
    // 在第一级页表上登记上 _end 对应的这一项
    pud[PUDX(_end)] = (freemem | PTE_VALID | PTE_TABLE | PTE_AF | PTE_USER | PTE_ISH | PTE_NORMAL);

    // 分配第二级页表
    pmd = (uint_64 *)freemem;
    freemem += BY2PG;

    // 我们在外循环填写第二级页表项
    int n_pmd_entry = 0x3f000000 >> 21;
    for (r = 0; r < n_pmd_entry; r++)
    {
        // 填写二级页表项
        pmd_entry = pmd + r;
        *pmd_entry = (freemem | PTE_VALID | PTE_TABLE | PTE_AF | PTE_USER | PTE_ISH | PTE_NORMAL);

        // 分配第三级页表
        pte = (uint_64 *)freemem;
        freemem += BY2PG;
        for (t = 0; t < 512; t++)
        {
            pte_entry = pte + t;
            // 填写三级页表项
            i = (r << 21) + (t << 12);
            if (i >= 0x80000 && i < (uint_64)(_data) - KERNEL_BASE)
            {
                (*pte_entry) = i | PTE_VALID | PTE_TABLE | PTE_AF | PTE_NORMAL | PTE_USER | PTE_RO;
                // it seems that all codesetions must be marked as read only
                // or the os can't run
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
        pmd[r] = ((r << 21) | PTE_VALID | PTE_AF | PTE_USER | PTE_DEVICE);
    }

    // 这里不知道为啥还需要填一项
    pud[PUDX(0x40000000)] = (freemem | PTE_VALID | PTE_TABLE | PTE_AF | PTE_USER | PTE_ISH | PTE_NORMAL);
    // 又分配了一个二级页表
    pmd = (uint_64 *)freemem;
    freemem += BY2PG;
    pmd[0] = (0x40000000 | PTE_VALID | PTE_AF | PTE_USER | PTE_DEVICE);

    return;
}