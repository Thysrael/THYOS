/*

这是用户的链接脚本。

这个脚本跟 MOS 的完全一致。

*/

ENTRY(_start)
SECTIONS
{
   . = 0x00400000;
    .text.boot : {
        *(.text.boot)
    }
  _text = .;			/* Text and read-only data */
  .text : {
	*(.text)
	*(.fixup)
	*(.gnu.warning)
	}

  _etext = .;			/* End of text section */

  .data : {			/* Data */
	*(.data)
	*(.rodata)
	*(.rodata.*)
	*(.eh_frame)
	CONSTRUCTORS
	}

  _edata = .;			/* End of data section */



  __bss_start = .;		/* BSS */
  .bss : {
	*(.bss)
	}
  /DISCARD/ : {
	*(.comment)
	*(.debug_*)
	}
  end = . ;

}