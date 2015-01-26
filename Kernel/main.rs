/*
 * Rust BareBones OS
 * - By John Hodge (Mutabah/thePowersGang) 
 *
 * main.rs
 * - Top-level file for kernel
 *
 * This code has been put into the public domain, there are no restrictions on
 * its use, and the author takes no liability.
 */
#![no_std]	//< Kernels can't use std
#![feature(lang_items)]	//< unwind needs to define lang items
#![feature(asm)]	//< As a kernel, we need inline assembly

use prelude::*;

// Load libcore (it's nice and freestanding)
extern crate core;

// Achitecture-specific modules
#[cfg(arch__amd64)] #[path="arch/amd64/mod.rs"]
mod arch;
#[cfg(arch__x86)] #[path="arch/x86/mod.rs"]
mod arch;

// Prelude
mod prelude;

/// Exception handling (panic)
mod unwind;

// Kernel entrypoint
#[lang="start"]
#[no_mangle]
fn kmain()
{
	unsafe {
		// The arch::debug functions are unsafe, as they do no synchronisation
		::arch::debug::puts("Hello World!\n")
	}
	loop {}
}

