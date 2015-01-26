
# CONFIG: Architecture to build for
ARCH ?= amd64

# Toolchain commands (can be overridden)
RUSTC ?= rustc
ifeq ($(ARCH),amd64)
    LD := x86_64-elf-ld
    LD := x86_64-elf-ld
    OBJDUMP := x86_64-elf-objdump
else ifeq ($(ARCH),x86)
    LD := i586-elf-ld
    AS := i586-elf-as
    OBJDUMP := i586-elf-objdump
else
    $(error Unknown architecture $(ARCH))
endif

# Object directory
OBJDIR := .obj/$(ARCH)/

# Compiler Options
LINKFLAGS := -T arch/$(ARCH)/link.ld
LINKFLAGS += -Map $(OBJDIR)map.txt
RUSTFLAGS := -O --cfg arch__$(ARCH) --target=arch/$(ARCH)/target.json

# Objects
LIBCORE := $(OBJDIR)libcore.rlib
OBJS := start.o kernel.o libcore.rlib

OBJS := $(OBJS:%=$(OBJDIR)%)

all: ../kernel.$(ARCH).bin

clean:
	$(RM) -rf ../kernel.$(ARCH).bin $(OBJDIR)

../kernel.$(ARCH).bin: $(OBJS) arch/$(ARCH)/link.ld
	$(LD) -o $@ $(LINKFLAGS) $(OBJS)
	$(OBJDUMP) -S $@ > $@.dsm

$(OBJDIR)libcore.rlib: ../libcore/lib.rs
	@mkdir -p $(dir $@)
	$(RUSTC) $(RUSTFLAGS) -o $@ --crate-type=lib $<

$(OBJDIR)kernel.o: main.rs $(LIBCORE)
	@mkdir -p $(dir $@)
	$(RUSTC) $(RUSTFLAGS) -o $@ --emit=obj $< --extern core=$(LIBCORE)

$(OBJDIR)start.o: arch/$(ARCH)/start.S
	@mkdir -p $(dir $@)
	$(AS) $(ASFLAGS) -o $@ $<
