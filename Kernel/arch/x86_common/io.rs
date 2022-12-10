/*
 * Rust BareBones OS
 * - By John Hodge (Mutabah/thePowersGang) 
 *
 * arch/x86/x86_io.rs
 * - Support for the x86 IO bus
 *
 * == LICENCE ==
 * This code has been put into the public domain, there are no restrictions on
 * its use, and the author takes no liability.
 */
#![allow(dead_code)]	// < This sample doesn't use them, but you might :)

/// Write a byte to the specified port
pub unsafe fn outb(port: u16, val: u8)
{
	::core::arch::asm!("out dx, al", in("dx") port, in("al") val, options(preserves_flags, nomem, nostack));
}

/// Read a single byte from the specified port
pub unsafe fn inb(port: u16) -> u8
{
	let ret : u8;
	::core::arch::asm!("in al, dx", out("al") ret, in("dx") port, options(preserves_flags, nomem, nostack));
	return ret;
}

/// Write a word (16-bits) to the specified port
pub unsafe fn outw(port: u16, val: u16)
{
	::core::arch::asm!("out dx, ax", in("dx") port, in("ax") val, options(preserves_flags, nomem, nostack));
}

/// Read a word (16-bits) from the specified port
pub unsafe fn inw(port: u16) -> u16
{
	let ret : u16;
	::core::arch::asm!("in eax, dx", out("eax") ret, in("dx") port, options(preserves_flags, nomem, nostack));
	return ret;
}

/// Write a long/double-word (32-bits) to the specified port
pub unsafe fn outl(port: u16, val: u32)
{
	::core::arch::asm!("out dx, eax", in("dx") port, in("eax") val, options(preserves_flags, nomem, nostack));
}

/// Read a long/double-word (32-bits) from the specified port
pub unsafe fn inl(port: u16) -> u32
{
	let ret : u32;
	::core::arch::asm!("in eax, dx", out("eax") ret, in("dx") port, options(preserves_flags, nomem, nostack));
	return ret;
}

