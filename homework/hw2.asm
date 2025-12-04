SECTION .data
buffer times 20 db 0

SECTION .text
global _start

int2str:
    push rbx
    push rcx
    push rdx

    mov rax, rdi
    mov rbx, 10
    mov rcx, 0

.loop:
    xor rdx, rdx
    div rbx
    add dl, '0'
    push rdx
    inc rcx
    cmp rax, 0
    jne .loop

    mov rsi, rsi
.write:
    pop rax
    mov [rsi], al
    inc rsi
    loop .write

    mov byte [rsi], 0
    pop rdx
    pop rcx
    pop rbx
    ret

_start:
    mov rdi, 1234567
    lea rsi, [buffer]
    call int2str

    mov rdx, 0
    mov rbx, buffer
.find_len:
    cmp byte [rbx+rdx], 0
    je .len_found
    inc rdx
    jmp .find_len
.len_found:
    mov rax, 1
    mov rdi, 1
    lea rsi, [buffer]
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall
