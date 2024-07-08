# Makefile to compile a bootloader and prepare it for VirtualBox on Windows

# Name of the bootloader source and output files
SRC = src\bootloader.asm
OBJ = build\bootloader.bin
FLOPPY = build\floppy.img
VDI = build\floppy.vdi

# Assembler and flags
ASM = nasm
ASMFLAGS = -f bin

# Create a VirtualBox disk image
$(VDI): $(FLOPPY)
	if exist $(VDI) del $(VDI)
	VBoxManage convertfromraw $(FLOPPY) $(VDI) --format VDI

# Create a floppy image
$(FLOPPY): $(OBJ)
	if exist $(FLOPPY) del $(FLOPPY)
	copy $(OBJ) $(FLOPPY)
	fsutil file seteof $(FLOPPY) 1474560

# Compile the bootloader
$(OBJ): $(SRC)
	$(ASM) $(ASMFLAGS) $(SRC) -o $(OBJ)


.PHONY: all
all: $(VDI)