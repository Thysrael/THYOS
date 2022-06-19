#include "types.h"

#define EI_NIDENT (16)

typedef uint_64 Elf64_Addr;
typedef uint_64	Elf64_Off;

typedef struct
{
    uint_8 e_ident[EI_NIDENT];          /* Magic number and other info */
    uint_16 e_type;                     /* Object file type */
	uint_16 e_machine;					/* Architecture */
	uint_32 e_version;             		/* Object file version */
	Elf64_Addr e_entry;					/* Entry point virtual address */
	Elf64_Off e_phoff;					/* Program header table file offset */
	Elf64_Off e_shoff;                	/* Section header table file offset */
    uint_32 e_flags;               		/* Processor-specific flags */
    uint_16 e_ehsize;              		/* ELF header size in bytes */
    uint_16 e_phentsize;           		/* Program header table entry size */
    uint_16 e_phnum;               		/* Program header table entry count */
    uint_16 e_shentsize;           		/* Section header table entry size */
    uint_16 e_shnum;               		/* Section header table entry count */
    uint_16 e_shstrndx;            		/* Section header string table index */
} Elf64_Ehdr;

/* 
Fields in the e_ident array.  The EI_* macros are indices into the
array.  The macros under each EI_* macro are the values the byte
may have.  
*/

#define EI_MAG0 0    /* File identification byte 0 index */
#define ELFMAG0 0x7f /* Magic number byte 0 */

#define EI_MAG1 1   /* File identification byte 1 index */
#define ELFMAG1 'E' /* Magic number byte 1 */

#define EI_MAG2 2   /* File identification byte 2 index */
#define ELFMAG2 'L' /* Magic number byte 2 */

#define EI_MAG3 3   /* File identification byte 3 index */
#define ELFMAG3 'F' /* Magic number byte 3 */

#define EI_CLASS 4
#define EI_CLASS_64 2   // '2' means the 64-bit format

/* Program segment header.  */

typedef struct
{
    uint_32 p_type;   		/* Segment type */
	uint_32 p_flags;		/* Segment-dependent flags (position for 64-bit structure) */
    Elf64_Off p_offset;  	/* Segment file offset */
	Elf64_Addr p_vaddr;  	/* Segment virtual address */
    Elf64_Addr p_paddr;  	/* Segment physical address */
    uint_64 p_filesz; 		/* Segment size in file */
    uint_64 p_memsz;  		/* Segment size in memory */
    uint_64 p_align;  		/* Segment alignment */
} Elf64_Phdr;

/* Legal values for p_type (segment type).  */

#define PT_NULL 0            /* Program header table entry unused */
#define PT_LOAD 1            /* Loadable program segment */
#define PT_DYNAMIC 2         /* Dynamic linking information */
#define PT_INTERP 3          /* Program interpreter */
#define PT_NOTE 4            /* Auxiliary information */
#define PT_SHLIB 5           /* Reserved */
#define PT_PHDR 6            /* Entry for header table itself */
#define PT_NUM 7             /* Number of defined types.  */
#define PT_LOOS 0x60000000   /* Start of OS-specific */
#define PT_HIOS 0x6fffffff   /* End of OS-specific */
#define PT_LOPROC 0x70000000 /* Start of processor-specific */
#define PT_HIPROC 0x7fffffff /* End of processor-specific */



int is_elf_format(u_char *binary);
int load_elf(u_char *binary, int size, uint_64 *entry_point, void *user_data,
			 int (*map)(uint_64 va, uint_64 sgsize, u_char *bin, uint_64 bin_size, void *user_data));
void load_icode(struct Env *e, u_char *binary, u_long size);
