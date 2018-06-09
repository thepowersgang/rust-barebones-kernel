/*
 * Rust BareBones OS
 * - By John Hodge (Mutabah/thePowersGang) 
 *
 * unwind.rs
 * - Stack unwind (panic) handling
 *
 * == LICENCE ==
 * This code has been put into the public domain, there are no restrictions on
 * its use, and the author takes no liability.
 */

#[panic_implementation]
#[no_mangle]	// This and pub neede for rust-lang/rust#51342
pub fn panic_implementation(info: &::core::panic::PanicInfo) -> !
{
	let (file,line) = match info.location()
		{
		Some(loc) => (loc.file(), loc.line(),),
		None => ("", 0),
		};
	if let Some(m) = info.message() {
		log!("PANIC file='{}', line={} :: {}", file, line, m);
	}
	else if let Some(m) = info.payload().downcast_ref::<&str>() {
		log!("PANIC file='{}', line={} :: {}", file, line, m);
	}
	else {
		log!("PANIC file='{}', line={} :: ?", file, line);
	}
	loop {}
}

#[allow(non_camel_case_types)]
#[repr(C)]
#[derive(Clone,Copy)]
pub enum _Unwind_Reason_Code
{
	_URC_NO_REASON = 0,
	_URC_FOREIGN_EXCEPTION_CAUGHT = 1,
	_URC_FATAL_PHASE2_ERROR = 2,
	_URC_FATAL_PHASE1_ERROR = 3,
	_URC_NORMAL_STOP = 4,
	_URC_END_OF_STACK = 5,
	_URC_HANDLER_FOUND = 6,
	_URC_INSTALL_CONTEXT = 7,
	_URC_CONTINUE_UNWIND = 8,
}

#[allow(non_camel_case_types)]
#[derive(Clone,Copy)]
pub struct _Unwind_Context;

#[allow(non_camel_case_types)]
pub type _Unwind_Action = u32;
static _UA_SEARCH_PHASE: _Unwind_Action = 1;

#[allow(non_camel_case_types)]
#[repr(C)]
#[derive(Clone,Copy)]
pub struct _Unwind_Exception
{
	exception_class: u64,
	exception_cleanup: fn(_Unwind_Reason_Code,*const _Unwind_Exception),
	private: [u64; 2],
}

#[no_mangle]
#[allow(non_snake_case)]
pub fn _Unwind_Resume()
{
	loop{}
}

