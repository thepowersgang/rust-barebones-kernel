/*
 * Rust BareBones OS
 * - By John Hodge (Mutabah/thePowersGang) 
 *
 * arcm/x86/start.S
 * - x86 Entrypoint
 *
 * == LICENCE ==
 * This code has been put into the public domain, there are no restrictions on
 * its use, and the author takes no liability.
 */

/* The kernel is linked to run at 3GB */
LINKED_BASE = 0xC0000000

/* === Multiboot Header === */
MULTIBOOT_PAGE_ALIGN  =  (1<<0)
MULTIBOOT_MEMORY_INFO =  (1<<1)
MULTIBOOT_REQVIDMODE  =  (1<<2)
MULTIBOOT_HEADER_MAGIC =  0x1BADB002
MULTIBOOT_HEADER_FLAGS = (MULTIBOOT_PAGE_ALIGN | MULTIBOOT_MEMORY_INFO | MULTIBOOT_REQVIDMODE)
MULTIBOOT_CHECKSUM     = -(MULTIBOOT_HEADER_MAGIC + MULTIBOOT_HEADER_FLAGS)
.section .multiboot, "a"
.globl mboot
mboot:
	.long MULTIBOOT_HEADER_MAGIC
	.long MULTIBOOT_HEADER_FLAGS
	.long MULTIBOOT_CHECKSUM
	.long mboot
	/* a.out kludge (not used, the kernel is elf) */
	.long 0, 0, 0, 0	/* load_addr, load_end_addr, bss_end_addr, entry_addr */
	/* Video mode */
	.long 0 	/* Mode type (0: LFB) */
	.long 0 	/* Width (no preference) */
	.long 0 	/* Height (no preference) */
	.long 32	/* Depth (32-bit preferred) */

.extern x86_prep_page_table
/* === Code === */
.section .inittext, "ax"
.globl start
start:
	/* Save multiboot state */
	mov %eax, mboot_sig - LINKED_BASE
	mov %ebx, mboot_ptr - LINKED_BASE
	
	/* XXX: Get rust code to prepare the page table */
	mov $init_stack - LINKED_BASE, %esp
	push $init_pt - LINKED_BASE
	call x86_prep_page_table - LINKED_BASE
	add 4, %esp
	
	/* Enable paging */
	mov $init_pd - LINKED_BASE, %eax
	mov %eax, %cr3
	mov %cr0, %eax
	or $0x80010000, %eax      /* PG & WP */
	mov %eax, %cr0
	
	lgdt GDTPtr
	
	/* Jump High and set CS */
	ljmp $0x08,$start_high
.section .text
.globl start_high
.extern kmain
start_high:
	/* Clear identity mapping */
	movl $0, init_pd+0
	
	/* Prep segment registers */	
	mov $0x10, %ax
	mov %ax, %ss
	mov %ax, %ds
	mov %ax, %es
	mov %ax, %fs
	mov %ax, %gs
	
	mov $init_stack, %esp
	call kmain
	
	/* If kmain returns, loop forefer */
.l:
	hlt
	jmp .l

/* === Page-aligned data === */
.section .padata
init_pd:
	.long init_pt - LINKED_BASE + 3
	.rept 768-1
		.long 0
	.endr
	.long init_pt - LINKED_BASE + 3
	.rept 256-1
		.long 0
	.endr
init_pt:
	/* The contents of this table is filled by the x86_prep_page_table function */
	.rept 1024
		.long 0
	.endr
	
/* === Read-write data === */
.section .data
.globl mboot_sig
.globl mboot_ptr
mboot_sig:
	.long 0
mboot_ptr:
	.long 0
GDTPtr:
	.word GDT - GDTEnd
	.long GDT
GDT:
	.long 0x00000000, 0x00000000	/* 00 NULL Entry */
	.long 0x0000FFFF, 0x00CF9A00	/* 08 PL0 Code */
	.long 0x0000FFFF, 0x00CF9200	/* 10 PL0 Data */
	.long 0x0000FFFF, 0x00CFFA00	/* 18 PL3 Code */
	.long 0x0000FFFF, 0x00CFF200	/* 20 PL3 Data */
GDTEnd:

	
.section .bss
	.space 0x1000*2
init_stack:

