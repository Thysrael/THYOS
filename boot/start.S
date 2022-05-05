.global _start

.section ".text.boot"
_start:
    mrs x0, mpidr_el1
    and x0, x0, #3 // & 0b11
    cbz x0, _start_master
1:  wfe
    b 1b

_start_master:
    adr     x1, _start
 // set up EL1
    mrs     x0, CurrentEL
    and     x0, x0, #12 // clear reserved bits

    // running at EL3?
    cmp     x0, #12
    bne     5f
    // should never be executed, just for completeness
    mov     x2, #0x5b1
    msr     scr_el3, x2
    mov     x2, #0x3c9
    msr     spsr_el3, x2
    adr     x2, 5f
    msr     elr_el3, x2
    eret

    // running at EL2?
5:  cmp     x0, #4
    beq     5f
    msr     sp_el1, x1
    // enable CNTP for EL1
    /*it seems that this part is unnecessary in lab1
    and from the reference,P2172,it seems that this code can give the access 
    to some registers from el1?*/
    mrs     x0, cnthctl_el2 
    orr     x0, x0, #3
    msr     cnthctl_el2, x0
    msr     cntvoff_el2, xzr

    // disable coprocessor traps
    mov     x0, #0x33FF
    msr     cptr_el2, x0    //essential! give access to SIMD,see reference 1891
    msr     hstr_el2, xzr //seems not so useful. reference P1931
    mov     x0, #(0xf << 20)//essential! give access to SIMD,see reference 3808
    msr     cpacr_el1, x0
    // enable AArch64 in EL1
    mov     x0, #(1 << 31)      // set to AArch64
    orr     x0, x0, #(1 << 1)   // SWIO hardwired on Pi3,Reference 1928 ???
    msr     hcr_el2, x0
    mrs     x0, hcr_el2
    // Setup SCTLR access
    mov     x2, #0x0800
    movk    x2, #0x30d0, lsl #16//MOVK :move with keep
    msr     sctlr_el1, x2
    // set up exception handlers
    //ldr     x2, =_vectors
    //msr     vbar_el1, x2
    // change execution level to EL1
    mov     x2, #0x004
    msr     spsr_el2, x2
    adr     x2, 5f
    msr     elr_el2, x2
    eret

5:  //mov     sp, x1

    // clear bss
    adr     x1, __bss_start
    ldr     w2, =__bss_size
3:  cbz     w2, 4f
    str     xzr, [x1], #8
    sub     w2, w2, #1
    cbnz    w2, 3b

    adr x0, _start
    mov sp, x0
4:
    msr spsel,#1
    adr     x0, init_page_table
    blr     x0
    adr     x0, enable_mmu
    blr     x0
    ldr     x0, =h
    br      x0

h:  
    ldr x0, =_start
    mov sp, x0
    bl main
    b 1b
