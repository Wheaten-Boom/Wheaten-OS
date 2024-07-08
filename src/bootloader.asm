org 0x7C00
BITS 16


start:
    mov si, msg
    call print

    jmp $

print:
    push ax
    push si

    mov ah, 0x0E
    .next_char:
        lodsb
        cmp al, 0
        je .done
        int 0x10
        jmp .next_char

    .done:
        pop si
        pop ax
        ret

msg: db "I'm coming for you", 0x0A, 0x0D, 0

times 510-($-$$) db 0
dw 0xAA55
