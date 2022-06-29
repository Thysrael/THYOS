#include "lib.h"
#include "mmu.h"
#include "pmap.h"

extern uint_64 *vpt;
extern uint_64 *vmd;
extern uint_64 *vud;
extern struct Page *pages;

int pageref(void *v)
{

	if (!(vud[PUDX(v)] & PTE_VALID))
	{
		return 0;
	}

	uint_64 vmd_entry = vmd[(PUDX(v) << 9) | PMDX(v)];
	if (!(vmd_entry & PTE_VALID))
	{
		return 0;
	}

	uint_64 pte = vpt[(PUDX(v) << 18) | (PMDX(v) << 9) | PTEX(v)];

	if (!(pte & PTE_VALID))
	{
		return 0;
	}

	return pages[PPN(pte)].pp_ref;
}
