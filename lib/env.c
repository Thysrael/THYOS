/*

这个文件主要是与进程管理有关的函数。

这个部分与 ABI 关系不大，所以难度不大。

具体与 ABI 有关的有，关于创建 vm 的时候的虚拟页表，还有进程切换的时候的 env_pop_tf

与加载用户程序段的内容被我放到了 load.c 中实现。

*/

#include "env.h"
#include "printf.h"
#include "mmu.h"
#include "pmap.h"
#include "tool.h"
#include "load.h"
#include "sched.h"

struct Env *envs = NULL;                // All environments
struct Env *curenv = NULL;              // the current env

static struct Env_list env_free_list;   // Free list
struct Env_list env_sched_list[2];      // Runnable list

extern uint_64 *kernel_pud;

// bitmap means every bit of bitmap is a flag
// ASID has 64 types, so we only need 64 bit to record it
static u_int asid_bitmap[2] = {0}; // 64

/* Overview:
 *  This function is to allocate an unused ASID
 *
 * Pre-Condition:
 *  the number of running processes should be less than 64
 *
 * Post-Condition:
 *  return the allocated ASID on success
 *  panic when too many processes are running
 */
static u_int asid_alloc()
{
    int i, index, inner;
    // we only need 6 bit for ASID
    for (i = 0; i < 64; ++i)
    {
        // index was the top bit of i
        index = i >> 5;
        // inner was the low 5 bit of i
        inner = i & 31;
        if ((asid_bitmap[index] & (1 << inner)) == 0)
        {
            asid_bitmap[index] |= 1 << inner;
            return i;
        }
    }
    panic("too many processes!");
}

/* Overview:
 *  When a process is killed, free its ASID
 *
 * Post-Condition:
 *  ASID is free and can be allocated again later
 */
static void asid_free(u_int i)
{
    int index, inner;
    index = i >> 5;
    inner = i & 31;
    asid_bitmap[index] &= ~(1 << inner);
}

/* Overview:
 *  This function is to make a unique ID for every env
 *
 * Pre-Condition:
 *  e should be valid
 *
 * Post-Condition:
 *  return e's envid on success
 */
u_int mkenvid(struct Env *e)
{
    u_int idx = e - envs;
    u_int asid = asid_alloc();
    // envid contains the asid and the index of envs
    return (asid << (1 + LOG2NENV)) | (1 << LOG2NENV) | idx;
}

/* Overview:
 *  Convert an envid to an env pointer.
 *  If envid is 0 , set *penv = curenv; otherwise set *penv = envs[ENVX(envid)];
 *
 * Pre-Condition:
 *  penv points to a valid struct Env *  pointer,
 *  envid is valid, i.e. for the result env which has this envid,
 *  its status isn't ENV_FREE,
 *  checkperm is 0 or 1.
 *
 * Post-Condition:
 *  return 0 on success,and set *penv to the environment.
 *  return -E_BAD_ENV on error,and set *penv to NULL.
 */
int envid2env(u_int envid, struct Env **penv, int checkperm)
{
    struct Env *e;
    /* Hint: If envid is zero, return curenv.*/
    /*Step 1: Assign value to e using envid. */
    if (envid == 0)
    {
        *penv = curenv;
        return 0;
    }

    e = &envs[ENVX(envid)];

    if (e->env_status == ENV_FREE || e->env_id != envid)
    {
        *penv = NULL;
        return -E_BAD_ENV;
    }
    /* Hints:
     *  Check whether the calling env has sufficient permissions
     *    to manipulate the specified env.
     *  If checkperm is set, the specified env
     *    must be either curenv or an immediate child of curenv.
     *  If not, error! */
    /*  Step 2: Make a check according to checkperm. */
    if (checkperm)
    {
        if (e != curenv && e->env_parent_id != curenv->env_id)
        {
            *penv = 0;
            return -E_BAD_ENV;
        }
    }

    *penv = e;
    return 0;
}

/* Overview:
 *  Mark all environments in 'envs' as free and insert them into the env_free_list.
 *  Insert in reverse order,so that the first call to env_alloc() returns envs[0].
 *
 * Hints:
 *  You may use these macro definitions below:
 *      LIST_INIT, LIST_INSERT_HEAD
 */
void env_init(void)
{
    int i;
    /* Step 1: Initialize env_free_list. */
    LIST_INIT(&env_free_list);

    LIST_INIT(env_sched_list);
    LIST_INIT(env_sched_list + 1);
    /*
     * Step 2: Traverse the elements of 'envs' array,
     * set their status as free and insert them into the env_free_list.
     * Choose the correct loop order to finish the insertion.
     * Make sure, after the insertion, the order of envs in the list
     * should be the same as that in the envs array.
     *
     */
    for (i = NENV - 1; i >= 0; i--)
    {
        envs[i].env_status = ENV_FREE;
        LIST_INSERT_HEAD(&env_free_list, &envs[i], env_link);
    }

    debug("Process management init success.\n");
}

/* Overview:
 *  Initialize the kernel virtual memory layout for 'e'.
 *  Allocate a page directory, set e->env_pgdir and e->env_cr3 accordingly,
 *    and initialize the kernel portion of the new env's address space.
 *  DO NOT map anything into the user portion of the env's virtual address space.
 */
static int env_setup_vm(struct Env *e)
{
    int i, r;
    struct Page *p = NULL;
    uint_64 *pgdir;

    /*
     *Step 1:
     *	Allocate a page for the page directory
     *  using a function you completed in the lab2 and add its pp_ref.
     *  pgdir is the page directory of Env e, assign value for it.
     */
    // page_alloc returning 0 means success
    if ((r = page_alloc(&p)) != 0)
    {
        panic("env_setup_vm - page alloc error\n");
        return r;
    }

    p->pp_ref++;
    pgdir = (uint_64 *)page2kva(p);

    // 这里直接 512 项初始化为 0 ，然后再进行内核的暴露
    for (i = 0; i < 512; i++)
    {
        pgdir[i] = 0;
    }

    pgdir[PUDX(UENVS)] = kernel_pud[PUDX(UENVS)];
    pgdir[PUDX(UPAGES)] = kernel_pud[PUDX(UPAGES)];

    // UVPT maps the env's own page table, with read-only permission.
    e->env_pgdir = pgdir;
    e->env_cr3 = PADDR(pgdir);
    // that's the self-map
    e->env_pgdir[PUDX(UVPT)] = e->env_cr3 | PTE_VALID | PTE_USER | PTE_ISH | PTE_NORMAL;

    return 0;
}

/* Overview:
 *  Allocate and Initialize a new environment.
 *  On success, the new environment is stored in *new.
 *
 * Pre-Condition:
 *  If the new Env doesn't have parent, parent_id should be zero.
 *  env_init has been called before this function.
 *
 * Post-Condition:
 *  return 0 on success, and set appropriate values of the new Env.
 *  return -E_NO_FREE_ENV on error, if no free env.
 *
 * Hints:
 *  You may use these functions and macro definitions:
 *      LIST_FIRST,LIST_REMOVE, mkenvid (Not All)
 *  You should set some states of Env:
 *      id , status , the sp register, CPU status , parent_id
 *      (the value of PC should NOT be set in env_alloc)
 */
int env_alloc(struct Env **new, u_int parent_id)
{
    struct Env *e;

    /* Step 1: Get a new Env from env_free_list*/
    if (LIST_EMPTY(&env_free_list))
    {
        *new = NULL;
        return -E_NO_FREE_ENV;
    }
    e = LIST_FIRST(&env_free_list);

    /* Step 2: Call a certain function (has been completed just now) to init kernel memory layout for this new Env.
     *The function mainly maps the kernel address to this new Env address. */
    if (env_setup_vm(e) == -E_NO_MEM)
    {
        *new = NULL;
        return -E_NO_FREE_ENV;
    }

    /* Step 3: Initialize every field of new Env with appropriate values.*/
    e->env_id = mkenvid(e);
    e->env_status = ENV_RUNNABLE;
    e->env_parent_id = parent_id;
    e->env_runs = 0;

    // TODO: 这里不知道要不要设置 pstate
    //e->env_tf.pstate = 0x1000100c;

    e->env_tf.sp = USTACKTOP;

    /* Step 5: Remove the new Env from env_free_list. */
    LIST_REMOVE(e, env_link);
    *new = e;
    return 0;
}

/* Overview:
 *  Allocate a new env with env_alloc, load the named elf binary into
 *  it with load_icode and then set its priority value. This function is
 *  ONLY called during kernel initialization, before running the FIRST
 *  user_mode environment.
 *
 * Hints:
 *  this function wraps the env_alloc and load_icode function.
 */
void env_create_priority(u_char *binary, int size, int priority)
{
    struct Env *e;
    /* Step 1: Use env_alloc to alloc a new env. */
    env_alloc(&e, 0);
    /* Step 2: assign priority to the new env. */
    e->env_pri = priority;
    /* Step 3: Use load_icode() to load the named elf binary,
       and insert it into env_sched_list using LIST_INSERT_HEAD. */
    load_icode(e, binary, size);
    
    LIST_INSERT_HEAD(env_sched_list, e, env_sched_link);
}
/* Overview:
 * Allocate a new env with default priority value.
 *
 * Hints:
 *  this function calls the env_create_priority function.
 */
void env_create(u_char *binary, int size)
{
    /* Step 1: Use env_create_priority to alloc a new env with priority 1 */
    env_create_priority(binary, size, 1);
    debug("Create a process.\n");
}

/* Overview:
 *  Free env e and all memory it uses.
 */
void env_free(struct Env *e)
{
    uint_64 pudno, pmdno, pteno, pa;
    uint_64 *pmd, *pt;
    debug("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
    
    for (pudno = 0; pudno < PUDX(UTOP); pudno++)
    {
        if (!((e->env_pgdir[pudno]) & PTE_VALID))
        {
            continue;
        }

        pmd = (uint_64 *)KADDR(PTE_ADDR(e->env_pgdir[pudno]));
        for (pmdno = 0; pmdno < 512; pmdno++)
        {
            if (!((pmd[pmdno]) & PTE_VALID))
            {
                continue;
            }

            pt = (uint_64 *)KADDR(PTE_ADDR(pmd[pmdno]));
            for (pteno = 0; pteno < 512; pteno++)
            {
                if (!((pt[pteno]) & PTE_VALID))
                {
                    page_remove(e->env_pgdir, (pudno << 30) + (pmdno << 21) + (pteno << 12));
                }
            }
            page_remove(e->env_pgdir, (uint_64)pt);
        }
        page_remove(e->env_pgdir, (uint_64)pmd);
    }
    pa = e->env_cr3;
    e->env_pgdir = 0;
    e->env_cr3 = 0;
    page_decref(pa2page(pa));
    e->env_status = ENV_FREE;
    LIST_INSERT_HEAD(&env_free_list, e, env_link);
    LIST_REMOVE(e, env_sched_link);
    asid_free(e->env_id >> 11);
    tlb_invalidate();
}

/* Overview:
 *  Free env e, and schedule to run a new env if e is the current env.
 */
void env_destroy(struct Env *e)
{
    /* Hint: free e. */
    printf("Env %lx has been killed ... \n", e->env_id);
    env_free(e);

    /* Hint: schedule to run a new environment. */
    if (curenv == e)
    {
        curenv = NULL;
        /* Hint: Why this? */
        bcopy((void *)KERNEL_SP - sizeof(struct Trapframe),
              (void *)TIMESTACK - sizeof(struct Trapframe),
              sizeof(struct Trapframe));
        sched_yield();
    }
}

/* Overview:
 *  Restore the register values in the Trapframe with env_pop_tf,
 *  and switch the context from 'curenv' to 'e'.
 *
 * Post-Condition:
 *  Set 'e' as the curenv running environment.
 *
 * Hints:
 *  You may use these functions:
 *      env_pop_tf , lcontext.
 */
void env_run(struct Env *e)
{
    /* Step 1: save register state of curenv. */
    /* Hint: if there is an environment running,
     *   you should switch the context and save the registers.
     *   You can imitate env_destroy() 's behaviors.*/
    if (curenv != NULL)
    {
        struct Trapframe *old = (struct Trapframe *)(TIMESTACK - sizeof(struct Trapframe));
        bcopy(old, &(curenv->env_tf), sizeof(struct Trapframe));
        // TODO: 这里似乎没有用
        // curenv->env_tf.pc = curenv->env_tf.cp0_epc;
    }
    /* Step 2: Set 'curenv' to the new environment. */
    curenv = e;
    set_ttbr0(curenv->env_cr3);
    tlb_invalidate();
    env_pop_tf(&(curenv->env_tf));
}