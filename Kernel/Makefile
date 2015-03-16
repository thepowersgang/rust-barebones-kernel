
# CONFIG: Architecture to build for
ARCH ?= amd64

# Toolchain commands (can be overridden)
RUSTC ?= rustc
ifeq ($(ARCH),amd64)
    LD := x86_64-elf-ld
    AS := x86_64-elf-as
    OBJDUMP := x86_64-elf-objdump
    OBJCOPY := x86_64-elf-objcopy
else ifeq ($(ARCH),x86)
    LD := i586-elf-ld
    AS := i586-elf-as
    OBJDUMP := i586-elf-objdump
else
    $(error Unknown architecture $(ARCH))
endif

# Object directory
OBJDIR := .obj/$(ARCH)/

LINKSCRIPT := arch/$(ARCH)/link.ld
TARGETSPEC := arch/$(ARCH)/target.json
# Compiler Options
LINKFLAGS := -T $(LINKSCRIPT)
LINKFLAGS += -Map $(OBJDIR)map.txt
LINKFLAGS += --gc-sections
LINKFLAGS += -z max-page-size=0x1000

RUSTFLAGS := -O --cfg arch__$(ARCH) --target=$(TARGETSPEC)
# - amd64 needs to be set to use soft floating point
ifeq ($(ARCH),amd64)
RUSTFLAGS += -C soft-float
endif

# Objects
LIBCORE := $(OBJDIR)libcore.rlib
OBJS := start.o kernel.o libcore.rlib
OBJS := $(OBJS:%=$(OBJDIR)%)
BIN := ../kernel.$(ARCH).bin

.PHONY: all clean

all: ../kernel.$(ARCH).bin

clean:
	$(RM) -rf $(BIN) $(BIN).dsm $(OBJDIR)

# Final link command
$(BIN): $(OBJS) arch/$(ARCH)/link.ld
	$(LD) -o $@ $(LINKFLAGS) $(OBJS)
	$(OBJDUMP) -S $@ > $@.dsm
ifeq ($(ARCH),amd64)
	@mv $@ $@.elf64
	@$(OBJCOPY) $@.elf64 -F elf32-i386 $@
endif

# Compile libcore from ../libcore/
$(OBJDIR)libcore.rlib: ../libcore/lib.rs Makefile $(TARGETSPEC)
	@mkdir -p $(dir $@)
	$(RUSTC) $(RUSTFLAGS) -o $@ --crate-type=lib --emit=link,dep-info $<

# Compile rust kernel object
$(OBJDIR)kernel.o: main.rs $(LIBCORE) Makefile $(TARGETSPEC)
	@mkdir -p $(dir $@)
	$(RUSTC) $(RUSTFLAGS) -o $@ --emit=obj,dep-info $< --extern core=$(LIBCORE)

# Compile architecture's assembly stub
$(OBJDIR)start.o: arch/$(ARCH)/start.S Makefile
	@mkdir -p $(dir $@)
	$(AS) $(ASFLAGS) -o $@ $<

# Include dependency files
-include $(OBJDIR)libcore.d $(OBJDIR)kernel.d $(OBJDIR)start.d
