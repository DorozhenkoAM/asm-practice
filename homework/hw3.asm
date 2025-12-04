SECTION .data
buffer times 20 db 0
yes db "prime", 10, 0
no db "not prime", 10, 0

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

strlen:
    mov rcx, 0
.lenloop:
    cmp byte [rdi+rcx], 0
    je .lendone
    inc rcx
    jmp .lenloop
.lendone:
    mov rax, rcx
    ret

print:
    mov rdi, rdi
    call strlen
    mov rdx, rax
    mov rax, 1
    mov rsi, rdi
    mov rdi, 1
    syscall
    ret

isprime:
    mov rax, rdi
    cmp rax, 2
    jl .not
    cmp rax, 2
    je .yesp

    mov rbx, 2
.check:
    mov rcx, rbx
    mov rdx, 0
    div rcx
    cmp rdx, 0
    je .not
    inc rbx
    cmp rbx, rdi
    jl .check
.yesp:
    mov rax, 1
    ret
.not:
    mov rax, 0
    ret

_start:
    mov rax, 29
    mov rdi, rax
    lea rsi, [buffer]
    call int2str

    lea rdi, [buffer]
    call print

    mov rdi, rax
    call isprime

    cmp rax, 1
    je .print_yes

    lea rdi, [no]
    call print
    jmp .exit

.print_yes:
    lea rdi, [yes]
    call print

.exit:
    mov rax, 60
    xor rdi, rdi
    syscall