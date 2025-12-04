section .text
global _start

_start:
    mov     eax, 123456789
    mov     esi, buffer
    call    int2str

    mov     edi, esi
    
    xor     edx, edx
count_len:
    cmp     byte [esi], 0
    je      print_it
    inc     esi
    inc     edx
    jmp     count_len

print_it:
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, edi
    int     0x80

    push    eax
    push    ebx
    push    ecx
    push    edx
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, newline
    mov     edx, 1
    int     0x80
    pop     edx
    pop     ecx
    pop     ebx
    pop     eax

    mov     eax, 1
    int     0x80

int2str:
    push    ebx
    push    ecx
    push    edx
    push    edi
    
    mov     edi, esi
    mov     ebx, 10
    
;перевірка на нуль
    test    eax, eax
    jnz     convert
    
;якщо нуль
    mov     byte [esi], '0'
    inc     esi
    mov     byte [esi], 0
    jmp     done
    
convert:
    xor     ecx, ecx
    
divide_loop:
    xor     edx, edx
    div     ebx
    
    add     dl, 48
    push    dx
    inc     ecx
    
    test    eax, eax
    jnz     divide_loop
    
    mov     esi, edi
    
pop_loop:
    pop     ax
    mov     [esi], al       
    inc     esi             
    loop    pop_loop
    
    mov     byte [esi], 0
    
done:
    mov     esi, edi
    pop     edi
    pop     edx
    pop     ecx
    pop     ebx
    ret

section .data
    newline db 10

section .bss
    buffer  resb 11