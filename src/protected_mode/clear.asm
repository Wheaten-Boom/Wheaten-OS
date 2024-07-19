[bits 32]

; Clear the VGA memory.
; Takes no arguments.
clear_screen:
; The pusha command stores the values of all
    ; registers so we don't have to worry about them
    pusha

    ; Set up constants
    mov ebx, vga_extent
    mov ecx, vga_start
    mov edx, 0

    ; Do main loop
    clear_loop:
        ; While edx < ebx
        cmp edx, ebx
        jge clear_done

        ; Free edx to use later
        push edx

        ; Move character to al, style to ah
        mov al, space_char
        mov ah, style_wb

        ; Print character to VGA memory
        add edx, ecx
        mov word[edx], ax

        ; Restore edx
        pop edx

        ; Increment counter
        add edx,2

        ; GOTO beginning of loop
        jmp clear_loop

clear_done:
    ; Restore all registers and return
    popa
    ret


space_char:                     equ ` `