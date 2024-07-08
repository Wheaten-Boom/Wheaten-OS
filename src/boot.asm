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

; We should now be able to read the loaded string
mov bx, loaded_msg
call print_bios

; And now we're going to threaten the user
mov bx, threatening_msg
call print_bios

; Infinite Loop
bootsector_hold:
jmp $               ; Infinite loop

; INCLUDES
%include "print.asm"
%include "print_hex.asm"
%include "load.asm"

; DATA STORAGE AREA

; String Message
booting_msg:                db "Booting the OS, Loading stage 2", 0x0A, 0x0D, 0

; Boot drive storage
boot_drive:                     db 0x00

; Pad boot sector for magic number
times 510 - ($ - $$) db 0x00

; Magic number
dw 0xAA55

bootsector_extended:

loaded_msg:                     db "Now reading from the next sector!", 0x0A, 0x0D, 0
threatening_msg:                db "And I'm coming for you!", 0x0A, 0x0D, 0

; Fill with zeros to the end of the sector
times 512 - ($ - bootsector_extended) db 0x00
