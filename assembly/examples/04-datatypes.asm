; Data Types and Storage Demo
; Demonstrates different data sizes, arrays, and structures

section .data
    ; Different data sizes
    byte_val    db 42           ; 8-bit value
    word_val    dw 1000         ; 16-bit value
    dword_val   dd 100000       ; 32-bit value
    
    ; Strings
    message     db 'Data Types Demo', 0xA, 0
    msg_len     equ $ - message - 1
    
    ; Arrays
    scores      db 85, 90, 78, 92, 88
    score_count equ ($ - scores)
    
    ; Lookup table
    hex_digits  db '0123456789ABCDEF'
    
    ; Structure simulation - Person record
    person1     db 'John Smith', 0, 0, 0, 0, 0  ; 16 bytes for name
                dd 25                            ; 4 bytes for age
                dd 50000                         ; 4 bytes for salary
    
    ; Structure offsets
    NAME_OFFSET   equ 0
    AGE_OFFSET    equ 16  
    SALARY_OFFSET equ 20

section .bss
    ; Uninitialized data (reserves space)
    buffer      resb 256        ; Reserve 256 bytes
    temp_word   resw 1          ; Reserve 1 word
    temp_dword  resd 1          ; Reserve 1 double word

section .text
    global _start

_start:
    ; Load different sized data
    mov al, [byte_val]      ; Load byte into AL (42)
    mov ax, [word_val]      ; Load word into AX (1000)
    mov eax, [dword_val]    ; Load dword into EAX (100000)
    
    ; Array access
    mov esi, scores         ; Point to array start
    mov al, [esi]          ; Get first element (85)
    mov al, [esi + 1]      ; Get second element (90)
    mov al, [esi + 4]      ; Get fifth element (88)
    
    ; Calculate array average
    xor eax, eax           ; Clear sum
    mov ecx, score_count   ; Loop counter
    mov esi, scores        ; Array pointer
    
sum_loop:
    movzx ebx, byte [esi]  ; Load byte and zero-extend to 32-bit
    add eax, ebx           ; Add to sum
    inc esi                ; Next element
    loop sum_loop          ; Continue for all elements
    
    ; Divide by count to get average
    mov ebx, score_count
    xor edx, edx           ; Clear remainder
    div ebx                ; EAX = average
    
    ; Hex digit lookup
    mov ebx, 10            ; Want hex digit for 10
    mov esi, hex_digits    ; Point to lookup table
    mov al, [esi + ebx]    ; Get 'A' (hex for 10)
    
    ; Access structure members
    mov esi, person1
    mov eax, [esi + AGE_OFFSET]     ; Get age (25)
    mov ebx, [esi + SALARY_OFFSET] ; Get salary (50000)
    
    ; Modify structure
    mov dword [esi + AGE_OFFSET], 26  ; Increment age
    
    ; Store in uninitialized space
    mov [temp_dword], eax  ; Store value in reserved space
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80
