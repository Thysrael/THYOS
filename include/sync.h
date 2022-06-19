#ifndef _SYNC_H_
#define _SYNC_H_

#include "trap.h"
#include "types.h"

void handle_sync(struct Trapframe *tf, uint_64 *ttbr0, uint_64 *ttbr1);

void page_fault_handler(struct Trapframe *tf);

#endif