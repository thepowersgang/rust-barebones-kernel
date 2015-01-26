/*
 * Rust BareBones OS
 * - By John Hodge (Mutabah/thePowersGang) 
 *
 * arch/x86/mod.rs
 * - Top-level file for x86 architecture
 *
 * == LICENCE ==
 * This code has been put into the public domain, there are no restrictions on
 * its use, and the author takes no liability.
 */

// x86 port IO 
mod x86_io;

// Debug output channel (uses serial)
pub mod debug;

#[no_mangle]
pub fn x86_prep_page_table(buf: &mut [u32; 1024])
{
	for i in 0u32 .. 1024
	{
		buf[i as usize] = i * 0x1000 + 3;
	}
}


