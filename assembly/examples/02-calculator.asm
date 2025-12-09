; Basic Calculator
; Demonstrates arithmetic operations and memory usage

section .data
    num1 dd 15          ; First number
    num2 dd 4           ; Second number
    sum dd 0            ; Storage for sum
    difference dd 0     ; Storage for difference  
    product dd 0        ; Storage for product
    quotient dd 0       ; Storage for quotient
    remainder dd 0      ; Storage for remainder

section .text
    global _start

_start:
    ; Load operands
    mov eax, [num1]     ; Load first number into EAX
    mov ebx, [num2]     ; Load second number into EBX
    
    ; Addition: num1 + num2
    add eax, ebx        ; EAX = num1 + num2
    mov [sum], eax      ; Store result
    
    ; Subtraction: num1 - num2
    mov eax, [num1]     ; Reload first number
    sub eax, ebx        ; EAX = num1 - num2
    mov [difference], eax
    
    ; Multiplication: num1 * num2
    mov eax, [num1]     ; Reload first number
    mul ebx             ; EAX = num1 * num2 (unsigned multiplication)
    mov [product], eax
    
    ; Division: num1 / num2
    mov eax, [num1]     ; Reload first number
    xor edx, edx        ; Clear EDX (required for division)
    div ebx             ; EAX = quotient, EDX = remainder
    mov [quotient], eax
    mov [remainder], edx
    
    ; Exit program
    mov eax, 1          ; sys_exit
    mov ebx, 0          ; exit status
    int 0x80
