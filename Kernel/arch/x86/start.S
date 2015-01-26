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
.section .multiboot
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

/* === Code === */
.section .text
.globl start
start:
	/* Save multiboot state */
	mov %eax, mboot_sig - LINKED_BASE
	mov %ebx, mboot_ptr - LINKED_BASE
.l:
	jmp .l

/* === Page-aligned data === */
.section .padata

/* === Read-write data === */
.section .data
mboot_sig:	.long 0
mboot_ptr:	.long 0

	
.section .bss
	.space 0x1000*2
init_stack:

