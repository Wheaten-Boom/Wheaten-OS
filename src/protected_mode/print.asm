[bits 32]


; Print a string to the screen.
; Takes a pointer to the string in ESI
print:
; The pusha command stores the values of all
    ; registers so we don't have to worry about them
    pusha
    mov edx, vga_start

    ; Do main loop
    print_loop:
        ; If char == \0, string is done
        cmp byte[esi], 0
        je  print_done

        ; Move character to al, style to ah
        mov al, byte[esi]
        mov ah, style_wb

        ; Print character to vga memory location
        mov word[edx], ax

        ; Increment counter registers
        add esi, 1
        add edx, 2

        ; Redo loop
        jmp print_loop

print_done:
    ; Popa does the opposite of pusha, and restores all of
    ; the registers
    popa
    ret