;
; Load More Code
;
; load.asm
;

[bits 16]

; Define load_sectors
;   Sector start point in bx
;   Number of sectors to read in cx
;   Destination address in dx
load_bios:
    ; Save the registers
    push ax
    push bx
    push cx
    push dx

    xor ax, ax
    ; We only want to load one sector from the disk for now. This will
    ; be higher later. Note: Only cl will be used
    mov al, 0x01       ; Set the number of sectors to read
    ; Save the number of sectors to read again, since we'll need
    ; to check against this later.
    push ax
    ; For the ATA Read bios utility, the value of ah must be 0x02
    ; See the BIOS article from Chapter 1.2 for more info
    mov ah, 0x02                ; BIOS read sector function goes in ah

    ; We want to store the new sector immediately after the first
    ; loaded sector, at address 0x7E00 (0x7C00 + 512 bytes).
    ; This will help a lot with jumping between different sectors of the bootloader.
    mov bx, 0x7E00      ; Destination address goes in bx

    ; The first sector's already been loaded, so we start with the second sector
    ; of the drive.
    mov cl, 0x02                   ; The sector to read goes in cl

    ; Next are the cylinder and cylinder head to read from. You
    ; would need to change these if reading from an actual drive, but with
    ; QEMU they're just 0
    mov ch, 0x00                ; Cylinder goes in ch
    mov dh, 0x00                ; Cylinder head goes in dh

    ; Finally, we want to load the drive to read from in dl. Remember,
    ; we stored this in the boot_drive label
    mov dl, byte [boot_drive]   ; Drive to read goes in dl

    ; Perform the BIOS disk read
    ; Use an interrupt to trigger the bios function
    int 0x13

    ; If there's a read error, then the BIOS function 
    ; will set the 'carry' bit in the 8086 special register.
    jc bios_disk_error

    ; Sometimes the BIOS will not read the requested amount, but
    ; will return without error. We need to check the actual read amount
    ; (stored in al). The number of sectors to read is stored in the
    ; stack, so we can pop it off and compare it to the actual read amount.
    pop bx
    cmp al, bl
    jne bios_disk_error

    ; If all goes well, we can now print the success message and return
    mov bx, success_msg
    call print_bios

    ; Restore the registers
    pop dx
    pop cx
    pop bx
    pop ax

    ; Return
    ret


bios_disk_error:
    ; Print out the error code and hang, since
    ; the program didn't work correctly
    mov bx, error_msg
    call print_bios

    ; The error code is in ah, so shift it down to mask out al
    shr ax, 8
    mov bx, ax
    call print_hex_bios

    ; Infinite loop to hang
    jmp $

error_msg:              db "ERROR Loading Sectors. Code: ", 0x0A, 0x0D, 0
success_msg:            db "Additional Sectors Loaded Successfully!", 0x0A, 0x0D, 0