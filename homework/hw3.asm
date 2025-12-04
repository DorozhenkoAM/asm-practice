section .text
global _start

_start:
    mov ax, 65      ; напишіть своє число для перевірки
    
    call prostoe
    
    mov esi, buf
    call v_stroku
    call print
    
    jnz net
    
    mov esi, da
    call print
    jmp konec
    
net:
    mov esi, netu
    call print
    
konec:
    mov eax, 1
    xor ebx, ebx
    int 0x80

prostoe:
    cmp ax, 1
    jle net_prostoe
    
    cmp ax, 2
    je da_prostoe
    cmp ax, 3
    je da_prostoe
    
    test ax, 1
    jz net_prostoe
    
    mov bx, 3
    
cikl:
    mov cx, ax
    shr cx, 1
    cmp bx, cx
    ja da_prostoe
    
    xor dx, dx
    mov cx, ax
    div bx
    
    test dx, dx
    jz net_prostoe
    
    add bx, 2
    jmp cikl
    
da_prostoe:
    xor ax, ax
    ret
    
net_prostoe:
    mov ax, 1
    test ax, ax
    ret

v_stroku:
    pusha
    
    mov edi, esi
    mov bx, 10
    xor cx, cx
    
    cmp ax, 0
    jne delen
    
    mov byte [esi], '0'
    inc esi
    mov byte [esi], 0
    jmp konec2
    
delen:
    xor dx, dx
    div bx
    add dl, '0'
    push dx
    inc cx
    cmp ax, 0
    jne delen
    
    mov esi, edi
    
obratno:
    pop ax
    mov [esi], al
    inc esi
    loop obratno
    
    mov byte [esi], 0
    
konec2:
    popa
    ret

print:
    pusha
    
    mov edi, esi
    xor ecx, ecx
    
schitat:
    cmp byte [edi], 0
    je pechat
    inc edi
    inc ecx
    jmp schitat
    
pechat:
    mov eax, 4
    mov ebx, 1
    mov edx, ecx
    mov ecx, esi
    int 0x80
    
    popa
    ret

section .data
    da   db " is prime", 10, 0
    netu db " is not prime", 10, 0

section .bss
    buf resb 10

;шла друга година ночі я хочу спати, не бийте за погану роботу