Rust Bare-Bones Kernel
=====

This is designed to be a rust equivalent of the OSDev.org Bare\_Bones article, presenting the bare minimum you need to get started.

Features
---
* x86 and x86\_64 (amd64) "ports"
* Initial paging for both (with higher-half)
* Serial output using the classic PC serial port, passing through the rust `::core::fmt` interface
* Links with libcore


Requirements
---
* A recent (1.0alpha) build of rustc
* A suitable cross-compiling copy of binutils (i586-elf or x86\_64-elf)
* A copy of the libcore source in .../libcore (synlink will do)

