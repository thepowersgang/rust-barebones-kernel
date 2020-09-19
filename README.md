Rust Bare-Bones Kernel
=====

This is designed to be a rust equivalent of the OSDev.org Bare\_Bones article, presenting the bare minimum you need to get started.


Requirements
---
* A recent (nightly) build of rustc (at least the date of the most recent commit to this repo)
* A suitable cross-compiling copy of binutils (i586-elf or x86\_64-elf)
 * by running `TRIPLE= make` instead of `make`, you can use the system linker, but it may not work.


Features
---
* x86 and x86\_64 (amd64) "ports"
* Initial paging for both (with higher-half)
* Serial output using the classic PC serial port, formatted using `::core::fmt`
* Links with libcore

Building
---

Roughly, this:

```bash
$ git clone https://github.com/thepowersgang/rust-barebones-kernel
$ cd rust-barebones-kernel
$ cd Kernel
$ make
$ cd ..
$ qemu-system-x86_64 -kernel kernel.amd64.bin -serial stdio
```

You should see a 

```text
[main] Hello world!
```

print to the console.

