ENTRY(start_low)
OUTPUT_FORMAT(elf32-i386)

KERNEL_BASE = 0xC0000000;

SECTIONS {
	. = 0x100000;
	. += SIZEOF_HEADERS;
	
	.multiboot : AT(ADDR(.multiboot)) {
		KEEP( *(.multiboot) )
	}
	
	. += KERNEL_BASE;
	
	.text : AT(ADDR(.text) - KERNEL_BASE) {
		*(.text .text.*)
	}
	
	start_low = start - KERNEL_BASE;
	
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
