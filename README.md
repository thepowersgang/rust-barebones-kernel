Rust Bare-Bones Kernel
=====

This is designed to be a rust equivalent of the OSDev.org Bare\_Bones article, presenting the bare minimum you need to get started.


Requirements
---
* A recent (1.0 nightly) build of rustc
* A suitable cross-compiling copy of binutils (i586-elf or x86\_64-elf)
* A copy of the libcore source in .../libcore (synlink will do)


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
$ # Make sure that you copy the libcore from the same commit as the build of rustc you're using
$ # If you're using a nightly or prepared build, you can use `rustc -v --version` to get a commit hash.
$ cp -r /some/installation/of/rust/src/libcore .
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

