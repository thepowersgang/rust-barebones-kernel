TRIPLE:=$(shell ./config.guess)-
ARCH ?= amd64

# Toolchain commands (can be overridden)
RUSTC ?= rustc
LD := $(TRIPLE)ld
AS := $(TRIPLE)as
OBJDUMP := $(TRIPLE)objdump
OBJCOPY := $(TRIPLE)objcopy

# Object directory
OBJDIR := .obj/$(ARCH)/

#Linker Options
LINKSCRIPT := arch/$(ARCH)/link.ld
LINKFLAGS := -T $(LINKSCRIPT) -Map $(OBJDIR)map.txt --gc-sections -z max-page-size=0x1000

# Compiler Options
TARGETSPEC := arch/$(ARCH)/target.json
RUSTFLAGS := -O --cfg arch__$(ARCH) --target=$(TARGETSPEC) -C soft-float

# Objects
LIBCORE := $(OBJDIR)libcore.rlib
OBJS := start.o kernel.o libcore.rlib
OBJS := $(OBJS:%=$(OBJDIR)%)
BIN := ../kernel.$(ARCH).bin

.PHONY: all clean UPDATE

all: $(BIN)

clean:
	$(RM) -rf $(BIN) $(BIN).dsm $(OBJDIR)

../rustc-nightly-src.tar.gz:
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
	tar -xmf ../rustc-nightly-src.tar.gz -C ../ rustc-nightly-src/src/libcore --transform 's~^rustc-nightly-src/src/~~'

# Compile libcore from ../libcore/
$(OBJDIR)libcore.rlib: ../libcore/lib.rs Makefile $(TARGETSPEC)
	@mkdir -p $(dir $@)
	$(RUSTC) $(RUSTFLAGS) --out-dir=$(OBJDIR) --crate-type=lib --crate-name=core --emit=link,dep-info $<

# Compile rust kernel object
$(OBJDIR)kernel.o: main.rs $(LIBCORE) Makefile $(TARGETSPEC)
	@mkdir -p $(dir $@)
	$(RUSTC) $(RUSTFLAGS) --out-dir=$(OBJDIR) --emit=obj,dep-info $< --extern core=$(LIBCORE)

# Compile architecture's assembly stub
$(OBJDIR)start.o: arch/$(ARCH)/start.S Makefile
	@mkdir -p $(dir $@)
	$(AS) $(ASFLAGS) -o $@ $<

# Include dependency files
-include $(OBJDIR)libcore.d $(OBJDIR)kernel.d $(OBJDIR)start.d
