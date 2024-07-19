;
; Load More Code
;
; boot.asm
;

; Set Program Origin
[org 0x7C00]

; 16-bit Mode
[bits 16]

; Initialize the base pointer and the stack pointer
; The initial values should be fine for what we've done so far,
; but it's better to do it explicitly
mov bp, 0x0500
mov sp, bp

; Before we do anything else, we want to save the ID of the boot
; drive, which the BIOS stores in register dl. We can offload this
; to a specific location in memory
mov byte[boot_drive], dl

; Print Message
mov bx, booting_msg
call print_bios

; Load the next sector
call load_bios

; And elevate to 32-bit mode
call elevate_bios

; Infinite Loop
bootsector_hold:
jmp $               ; Infinite loop

; INCLUDES
%include "real_mode/print.asm"
%include "real_mode/print_hex.asm"
%include "real_mode/load.asm"
%include "real_mode/gdt.asm"
%include "real_mode/elevate.asm"

; DATA STORAGE AREA

; String Message
booting_msg:                db "Booting the OS, Loading stage 2", 0x0A, 0x0D, 0

; Boot drive storage
boot_drive:                     db 0x00

; Pad boot sector for magic number
times 510 - ($ - $$) db 0x00

; Magic number
dw 0xAA55


; START OF THE SECOND SECTOR - ONLY 32-BIT CODE FROM HERE

bootsector_extended:
begin_protected:

; Clear the screen
call clear_screen

; Print a message
mov esi, threatening_msg
call print

; Infinite loop
jmp $

; INCLUDES
%include "protected_mode/print.asm"
%include "protected_mode/clear.asm"

; DATA STORAGE AREA

; String Message
threatening_msg:                db "I'm coming for you!", 0
protected_msg:                  db "Now in 32-bit protected mode!", 0

; Constants
vga_start:                  equ 0x000B8000
vga_extent:                 equ 80 * 25 * 2             ; VGA Memory is 80 chars wide by 25 chars tall (one char is 2 bytes)
style_wb:                   equ 0x0F

; Fill with zeros to the end of the sector
times 512 - ($ - bootsector_extended) db 0x00
