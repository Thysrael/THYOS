ENTRY(_start)

SECTIONS
{
    . = 0xffffff8000080000;
    /*
    It is important to start the text segment with the Assembly code,
    because we set the stack right before it, hence the KEEP().
    This way our load address is 0x80000,
    the same as `_start` label and stack top.
    */
    .text :
    {
        KEEP(*(.text.boot))
        *(.text .text.* .gnu.linkonce.t*)
    }

    .rodata :
    {
        *(.rodata .rodata.* .gnu.linkonce.r*)
    }
    /*
    ALIG() Return the location counter (.) or arbitrary expression aligned to the next align boundary.
    */
    . = ALIGN(4096);

    /*
    we use PROVIDE to declare some symbols not declared in other object files
    */
    PROVIDE(_data = .);
    .data :
    {
        *(.data .data.* .gnu.linkonce.d*)
    }

    /*
    The section should be marked as not loadable,
    so that it will not be loaded into memory when the program is run.
    */
    .bss (NOLOAD) :
    {
        . = ALIGN(16);
        __bss_start = .;
        *(.bss .bss.*)
        /*
        A special notation is needed for common symbols,
        because in many object file formats common symbols do not have a particular input section.
        The linker treats common symbols as though they are in an input section named ‘COMMON’.
        */
        *(COMMON)
        __bss_end = .;
    }

    . = ALIGN(4096);

    _end = .;
    _pg_dir = .;
}

/*
The symbol we defined here is used in start.S to clear the bss region,
the reason ">> 3" is the clear is at garentity of a word(8 byte)
*/
__bss_size = (__bss_end - __bss_start) >> 3;
