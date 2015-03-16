ENTRY(start)
OUTPUT_FORMAT(elf32-i386)

KERNEL_BASE = 0xC0000000;

SECTIONS {
	. = 0x100000;
	. += SIZEOF_HEADERS;
	
	.init : AT(ADDR(.init)) {
		KEEP( *(.multiboot) )
		*(.inittext)
	}
	
	. += KERNEL_BASE;
	
	.text ALIGN(0x1000) : AT(ADDR(.text) - KERNEL_BASE) {
		*(.text .text.*)
	}
	
	/* read-only data, page aligned to allow use of the no-execute feature */
	. = ALIGN(0x1000);
	.rodata : AT(ADDR(.rodata) - KERNEL_BASE) {
		*(.rodata .rodata.*)
	}
	
	/* Read-write data, page aligned for the .padata section */
	. = ALIGN(0x1000);
	.data : AT(ADDR(.data) - KERNEL_BASE) {
		*(.padata)
		*(.data .data.*)
	}
	
	/* Zero-initialised data */
	.bss : AT(ADDR(.bss) - KERNEL_BASE) {
		*(.bss .bss.*)
	}
	
	. = ALIGN(0x1000);
	kernel_end = .;
}
