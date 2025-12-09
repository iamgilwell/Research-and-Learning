; Functions and Procedures Demo
; Demonstrates function calls, parameters, and return values

section .data
    num1 dd 15
    num2 dd 25
    result dd 0
    factorial_input dd 5
    factorial_result dd 0

section .text
    global _start

_start:
    ; Test simple function with register parameters
    mov eax, [num1]        ; Load first number
    mov ebx, [num2]        ; Load second number
    call add_numbers       ; Call function
    mov [result], eax      ; Store result
    
    ; Test function with stack parameters
    push dword [num2]      ; Push second parameter
    push dword [num1]      ; Push first parameter
    call multiply_stack    ; Call function
    add esp, 8             ; Clean up stack (2 parameters × 4 bytes)
    
    ; Test recursive factorial function
    push dword [factorial_input] ; Push parameter
    call factorial         ; Call recursive function
    add esp, 4             ; Clean up parameter
    mov [factorial_result], eax ; Store result
    
    ; Test string length function
    push test_string       ; Push string pointer
    call strlen            ; Call function
    add esp, 4             ; Clean up parameter
    ; EAX now contains string length
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80

; Function: Add two numbers (register parameters)
; Input: EAX = first number, EBX = second number
; Output: EAX = sum
add_numbers:
    add eax, ebx           ; Add the numbers
    ret                    ; Return result in EAX

; Function: Multiply two numbers (stack parameters)
; Input: [ESP + 4] = first number, [ESP + 8] = second number
; Output: EAX = product
multiply_stack:
    push ebp               ; Save base pointer
    mov ebp, esp           ; Set up stack frame
    
    mov eax, [ebp + 8]     ; Get first parameter
    imul eax, [ebp + 12]   ; Multiply by second parameter
    
    pop ebp                ; Restore base pointer
    ret                    ; Return product in EAX

; Function: Calculate factorial recursively
; Input: [EBP + 8] = n
; Output: EAX = n!
factorial:
    push ebp               ; Function prologue
    mov ebp, esp
    
    mov eax, [ebp + 8]     ; Get parameter n
    
    ; Base case: if n <= 1, return 1
    cmp eax, 1
    jle factorial_base
    
    ; Recursive case: n * factorial(n-1)
    dec eax                ; n - 1
    push eax               ; Push n-1 as parameter
    call factorial         ; Recursive call
    add esp, 4             ; Clean up parameter
    
    ; EAX now contains factorial(n-1)
    imul eax, [ebp + 8]    ; Multiply by n
    jmp factorial_end
    
factorial_base:
    mov eax, 1             ; Return 1 for base case
    
factorial_end:
    pop ebp                ; Function epilogue
    ret

; Function: Calculate string length
; Input: [EBP + 8] = string pointer
; Output: EAX = string length
strlen:
    push ebp               ; Function prologue
    mov ebp, esp
    push esi               ; Save register
    
    mov esi, [ebp + 8]     ; Get string pointer
    xor eax, eax           ; Length counter = 0
    
strlen_loop:
    cmp byte [esi + eax], 0 ; Check for null terminator
    je strlen_done         ; Jump if end of string
    inc eax                ; Increment length
    jmp strlen_loop        ; Continue counting
    
strlen_done:
    pop esi                ; Restore register
    pop ebp                ; Function epilogue
    ret

section .data
    test_string db 'Hello, Functions!', 0
