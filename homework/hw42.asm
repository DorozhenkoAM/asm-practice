SECTION .data
buf1 times 20 db 0
buf2 times 20 db 0

SECTION .text
global _start

int2str:
    push rbx
    push rcx
    push rdx
    mov rax,rdi
    mov rbx,10
    mov rcx,0
.i:
    xor rdx,rdx
    div rbx
    add dl,'0'
    push rdx
    inc rcx
    cmp rax,0
    jne .i
    mov rsi,rsi
.w:
    pop rax
    mov [rsi],al
    inc rsi
    loop .w
    mov byte [rsi],0
    pop rdx
    pop rcx
    pop rbx
    ret

strlen:
    mov rcx,0
.l:
    cmp byte [rdi+rcx],0
    je .d
    inc rcx
    jmp .l
.d:
    mov rax,rcx
    ret

print:
    call strlen
    mov rdx,rax
    mov rax,1
    mov rsi,rdi
    mov rdi,1
    syscall
    ret

factorial_rec:
    cmp ax,1
    jle .base
    push ax
    dec ax
    call factorial_rec
    pop bx
    mul bx
    ret
.base:
    mov ax,1
    mov dx,0
    ret

_start:
    mov ax,5
    mov di,ax
    lea rsi,[buf1]
    mov rdi,rax
    call int2str
    lea rdi,[buf1]
    call print

    mov ax,5
    call factorial_rec

    mov rdi,rax
    lea rsi,[buf2]
    call int2str
    lea rdi,[buf2]
    call print

    mov rax,60
    xor rdi,rdi
    syscall