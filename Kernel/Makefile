
# CONFIG: Architecture to build for
ARCH ?= amd64

ifeq ($(ARCH),amd64)
    TRIPLE ?= x86_64-none-elf-
else ifeq ($(ARCH),x86)
    TRIPLE ?= i686-elf-
else
    $(error Unknown architecture $(ARCH))
endif


# Toolchain commands (can be overridden)
RUSTC ?= rustc
LD := $(TRIPLE)ld
AS := $(TRIPLE)as
OBJDUMP := $(TRIPLE)objdump
OBJCOPY := $(TRIPLE)objcopy

# Object directory
OBJDIR := .obj/$(ARCH)/

LINKSCRIPT := arch/$(ARCH)/link.ld
TARGETSPEC := arch/$(ARCH)/target.json
# Compiler Options
LINKFLAGS := -T $(LINKSCRIPT)
LINKFLAGS += -Map $(OBJDIR)map.txt
LINKFLAGS += --gc-sections
LINKFLAGS += -z max-page-size=0x1000

RUSTFLAGS := -O --cfg arch__$(ARCH) --target=$(TARGETSPEC) -C soft-float
RUSTFLAGS += -C panic=abort

# Objects
LIBCORE := $(OBJDIR)libcore.rlib
OBJS := start.o kernel.o libcore.rlib libcompiler_builtins.rlib
OBJS := $(OBJS:%=$(OBJDIR)%)
BIN := ../kernel.$(ARCH).bin

.PHONY: all clean UPDATE

all: $(BIN)

clean:
	$(RM) -rf $(BIN) $(BIN).dsm $(OBJDIR)

UPDATE:
	curl https://static.rust-lang.org/dist/rustc-nightly-src.tar.gz -o ../rustc-nightly-src.tar.gz

# Final link command
$(BIN): $(OBJS) arch/$(ARCH)/link.ld
	$(LD) -o $@ $(LINKFLAGS) $(OBJS)
	$(OBJDUMP) -S $@ > $@.dsm
ifeq ($(ARCH),amd64)
	@mv $@ $@.elf64
	@$(OBJCOPY) $@.elf64 -F elf32-i386 $@
endif

../libcore/lib.rs: ../rustc-nightly-src.tar.gz
	tar -xmf ../rustc-nightly-src.tar.gz -C ../ rustc-nightly-src/src/libcore rustc-nightly-src/src/stdsimd --transform 's~^rustc-nightly-src/src/~~'
../libcompiler_builtins/src/lib.rs: ../rustc-nightly-src.tar.gz
	tar -xmf ../rustc-nightly-src.tar.gz -C ../ rustc-nightly-src/src/libcompiler_builtins --transform 's~^rustc-nightly-src/src/~~'

# Compile libcore from ../libcore/
$(OBJDIR)libcore.rlib: ../libcore/lib.rs Makefile $(TARGETSPEC)
	@mkdir -p $(dir $@)
	$(RUSTC) $(RUSTFLAGS) --out-dir=$(OBJDIR) --crate-type=lib --crate-name=core --emit=link,dep-info $<
$(OBJDIR)libcompiler_builtins.rlib: ../libcompiler_builtins/src/lib.rs Makefile $(TARGETSPEC) $(OBJDIR)libcore.rlib
	@mkdir -p $(dir $@)
	$(RUSTC) $(RUSTFLAGS) --out-dir=$(OBJDIR) --cfg feature=\"compiler-builtins\" --emit=link,dep-info --extern core=$(LIBCORE) $<

# Compile rust kernel object
$(OBJDIR)kernel.o: main.rs $(LIBCORE) $(OBJDIR)libcompiler_builtins.rlib Makefile $(TARGETSPEC)
	@mkdir -p $(dir $@)
	$(RUSTC) $(RUSTFLAGS) --out-dir=$(OBJDIR) --emit=obj,dep-info $< --extern core=$(LIBCORE) -L $(OBJDIR)

# Compile architecture's assembly stub
$(OBJDIR)start.o: arch/$(ARCH)/start.S Makefile
	@mkdir -p $(dir $@)
	$(AS) $(ASFLAGS) -o $@ $<


# Include dependency files
-include $(OBJDIR)libcore.d $(OBJDIR)kernel.d $(OBJDIR)start.d
