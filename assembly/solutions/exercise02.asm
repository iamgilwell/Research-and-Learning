; Solution: Exercise 2 - Register Manipulation
; Demonstrates XOR swap technique

section .data
    num1 dd 42          ; First number
    num2 dd 17          ; Second number

section .text
    global _start

_start:
    ; Load numbers into registers
    mov eax, [num1]     ; EAX = 42
    mov ebx, [num2]     ; EBX = 17
    
    ; XOR swap technique
    xor eax, ebx        ; EAX = 42 XOR 17 = 59
    xor ebx, eax        ; EBX = 17 XOR 59 = 42 (original EAX value)
    xor eax, ebx        ; EAX = 59 XOR 42 = 17 (original EBX value)
    
    ; Store swapped values back to memory
    mov [num1], eax     ; num1 = 17
    mov [num2], ebx     ; num2 = 42
    
    ; Exit program
    mov eax, 1          ; sys_exit
    mov ebx, 0          ; exit status
    int 0x80            ; system call

; Bonus: 2-register swap (using stack)
; Alternative implementation:
;   push eax          ; Save EAX on stack
;   mov eax, ebx      ; EAX = EBX
;   pop ebx           ; EBX = original EAX
