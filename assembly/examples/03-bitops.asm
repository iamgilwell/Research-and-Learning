; Bit Operations Demo
; Demonstrates bitwise operations and bit manipulation

section .data
    number dd 12        ; Test number (binary: 1100)
    result1 dd 0        ; Storage for results
    result2 dd 0
    result3 dd 0
    result4 dd 0

section .text
    global _start

_start:
    mov eax, [number]   ; Load test number (12 = 1100 binary)
    
    ; Left shift (multiply by 2^n)
    mov ebx, eax        ; Copy original number
    shl ebx, 2          ; Shift left 2 positions (multiply by 4)
    mov [result1], ebx  ; Store result (48 = 110000 binary)
    
    ; Right shift (divide by 2^n)  
    mov ebx, eax        ; Copy original number
    shr ebx, 1          ; Shift right 1 position (divide by 2)
    mov [result2], ebx  ; Store result (6 = 110 binary)
    
    ; Bitwise AND (mask bits)
    mov ebx, eax        ; Copy original number
    and ebx, 0x0F       ; Keep only lower 4 bits (mask with 00001111)
    mov [result3], ebx  ; Store result (12 = 1100 binary, unchanged)
    
    ; Bitwise OR (set bits)
    mov ebx, eax        ; Copy original number  
    or ebx, 0x01        ; Set bit 0 (OR with 00000001)
    mov [result4], ebx  ; Store result (13 = 1101 binary)
    
    ; XOR trick: clear register efficiently
    xor ecx, ecx        ; ECX = 0 (faster than mov ecx, 0)
    
    ; Exit program
    mov eax, 1
    mov ebx, 0
    int 0x80
