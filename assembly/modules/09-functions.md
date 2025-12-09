# Module 9: Functions and Procedures

## Function Basics

Functions in assembly are implemented using labels, the stack, and calling conventions. They allow code reuse and modular programming.

## Simple Function Call

### Basic Function Structure
```assembly
section .text
    global _start

_start:
    ; Call a function
    call my_function       ; Push return address and jump
    
    ; Continue after function returns
    mov eax, 1
    mov ebx, 0
    int 0x80

my_function:
    ; Function body
    ; Do some work here
    
    ret                    ; Pop return address and jump back
```

## Parameter Passing

### Using Registers (Simple Method)
```assembly
section .data
    result dd 0

section .text
    global _start

_start:
    ; Pass parameters in registers
    mov eax, 15            ; First parameter
    mov ebx, 25            ; Second parameter
    call add_numbers       ; Call function
    
    mov [result], eax      ; Store result
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80

add_numbers:
    ; Function: add two numbers
    ; Input: EAX = first number, EBX = second number
    ; Output: EAX = sum
    add eax, ebx           ; Add the numbers
    ret                    ; Return result in EAX
```

### Using Stack (Standard Method)
```assembly
section .data
    result dd 0

section .text
    global _start

_start:
    ; Push parameters onto stack (right to left)
    push 25                ; Second parameter
    push 15                ; First parameter
    call add_numbers_stack ; Call function
    add esp, 8             ; Clean up stack (2 parameters × 4 bytes)
    
    mov [result], eax      ; Store result
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80

add_numbers_stack:
    ; Function with stack parameters
    ; Stack layout:
    ; [ESP + 8] = first parameter (15)
    ; [ESP + 4] = second parameter (25)  
    ; [ESP]     = return address
    
    mov eax, [esp + 4]     ; Get first parameter
    add eax, [esp + 8]     ; Add second parameter
    ret                    ; Return sum in EAX
```

## Stack Frame Management

### Standard Function Prologue/Epilogue
```assembly
section .text
    global _start

_start:
    push 10                ; Parameter 2
    push 5                 ; Parameter 1
    call multiply_function
    add esp, 8             ; Clean up parameters
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80

multiply_function:
    ; Standard function prologue
    push ebp               ; Save caller's base pointer
    mov ebp, esp           ; Set up new base pointer
    
    ; Now we can access parameters relative to EBP:
    ; [EBP + 8]  = first parameter (5)
    ; [EBP + 12] = second parameter (10)
    ; [EBP + 4]  = return address
    ; [EBP]      = saved EBP
    
    mov eax, [ebp + 8]     ; Get first parameter
    imul eax, [ebp + 12]   ; Multiply by second parameter
    
    ; Standard function epilogue
    mov esp, ebp           ; Restore stack pointer
    pop ebp                ; Restore caller's base pointer
    ret                    ; Return to caller
```

## Local Variables

### Function with Local Variables
```assembly
section .text
    global _start

_start:
    push 100               ; Parameter: array size
    call initialize_array
    add esp, 4             ; Clean up parameter
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80

initialize_array:
    ; Function with local variables
    push ebp               ; Save base pointer
    mov ebp, esp           ; Set up stack frame
    
    ; Allocate space for local variables
    sub esp, 12            ; Reserve 12 bytes for locals
    ; [EBP - 4]  = local variable 1 (counter)
    ; [EBP - 8]  = local variable 2 (temp value)
    ; [EBP - 12] = local variable 3 (array pointer)
    
    ; Initialize local variables
    mov dword [ebp - 4], 0    ; counter = 0
    mov dword [ebp - 8], 42   ; temp = 42
    
    ; Function body using local variables
    mov ecx, [ebp + 8]        ; Get parameter (array size)
    
init_loop:
    ; Use local variables
    mov eax, [ebp - 4]        ; Get counter
    inc eax                   ; Increment
    mov [ebp - 4], eax        ; Store back
    
    ; Loop logic here
    loop init_loop
    
    ; Function epilogue
    mov esp, ebp           ; Deallocate locals
    pop ebp                ; Restore base pointer
    ret
```

## Recursive Functions

### Factorial Function
```assembly
section .data
    number dd 5
    result dd 0

section .text
    global _start

_start:
    push dword [number]    ; Push parameter
    call factorial         ; Call recursive function
    add esp, 4             ; Clean up parameter
    
    mov [result], eax      ; Store result
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80

factorial:
    ; Recursive factorial function
    ; Input: [EBP + 8] = n
    ; Output: EAX = n!
    
    push ebp               ; Function prologue
    mov ebp, esp
    
    mov eax, [ebp + 8]     ; Get parameter n
    
    ; Base case: if n <= 1, return 1
    cmp eax, 1
    jle base_case
    
    ; Recursive case: n * factorial(n-1)
    dec eax                ; n - 1
    push eax               ; Push n-1 as parameter
    call factorial         ; Recursive call
    add esp, 4             ; Clean up parameter
    
    ; EAX now contains factorial(n-1)
    imul eax, [ebp + 8]    ; Multiply by n
    jmp factorial_end
    
base_case:
    mov eax, 1             ; Return 1 for base case
    
factorial_end:
    pop ebp                ; Function epilogue
    ret
```

## Function Pointer Arrays

### Jump Table Implementation
```assembly
section .data
    ; Function pointer table
    operations dd add_func, sub_func, mul_func, div_func
    
section .text
    global _start

_start:
    ; Call function based on index
    mov eax, 2             ; Operation index (multiply)
    mov ebx, 10            ; First operand
    mov ecx, 5             ; Second operand
    
    ; Call function through table
    call [operations + eax*4] ; Call operations[2] (mul_func)
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80

add_func:
    ; Addition function
    ; Input: EBX = a, ECX = b
    ; Output: EAX = a + b
    mov eax, ebx
    add eax, ecx
    ret

sub_func:
    ; Subtraction function
    mov eax, ebx
    sub eax, ecx
    ret

mul_func:
    ; Multiplication function
    mov eax, ebx
    imul eax, ecx
    ret

div_func:
    ; Division function
    mov eax, ebx
    xor edx, edx           ; Clear remainder
    div ecx                ; Divide EAX by ECX
    ret
```

## String Processing Functions

### String Length Function
```assembly
section .data
    test_string db 'Hello, World!', 0
    length dd 0

section .text
    global _start

_start:
    push test_string       ; Push string pointer
    call strlen            ; Call string length function
    add esp, 4             ; Clean up parameter
    
    mov [length], eax      ; Store result
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80

strlen:
    ; String length function
    ; Input: [EBP + 8] = string pointer
    ; Output: EAX = string length
    
    push ebp               ; Function prologue
    mov ebp, esp
    push esi               ; Save registers we'll use
    
    mov esi, [ebp + 8]     ; Get string pointer
    xor eax, eax           ; Length counter = 0
    
strlen_loop:
    cmp byte [esi + eax], 0 ; Check for null terminator
    je strlen_done         ; Jump if end of string
    inc eax                ; Increment length
    jmp strlen_loop        ; Continue counting
    
strlen_done:
    pop esi                ; Restore registers
    pop ebp                ; Function epilogue
    ret
```

### String Copy Function
```assembly
section .data
    source db 'Copy this string', 0
    
section .bss
    destination resb 50

section .text
    global _start

_start:
    push destination       ; Destination pointer
    push source            ; Source pointer
    call strcpy            ; Call string copy function
    add esp, 8             ; Clean up parameters
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80

strcpy:
    ; String copy function
    ; Input: [EBP + 8] = source, [EBP + 12] = destination
    ; Output: EAX = destination pointer
    
    push ebp               ; Function prologue
    mov ebp, esp
    push esi               ; Save registers
    push edi
    
    mov esi, [ebp + 8]     ; Source pointer
    mov edi, [ebp + 12]    ; Destination pointer
    mov eax, edi           ; Return value = destination
    
strcpy_loop:
    mov bl, [esi]          ; Get source character
    mov [edi], bl          ; Store in destination
    test bl, bl            ; Check if null terminator
    jz strcpy_done         ; Jump if end of string
    inc esi                ; Next source character
    inc edi                ; Next destination position
    jmp strcpy_loop        ; Continue copying
    
strcpy_done:
    pop edi                ; Restore registers
    pop esi
    pop ebp                ; Function epilogue
    ret
```

## Advanced Function Concepts

### Function with Variable Arguments
```assembly
section .text
    global _start

_start:
    ; Call function with variable number of arguments
    push 30                ; Argument 3
    push 20                ; Argument 2  
    push 10                ; Argument 1
    push 3                 ; Number of arguments
    call sum_varargs       ; Call function
    add esp, 16            ; Clean up all parameters
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80

sum_varargs:
    ; Function that sums variable number of arguments
    ; Input: [EBP + 8] = count, [EBP + 12]... = arguments
    ; Output: EAX = sum
    
    push ebp               ; Function prologue
    mov ebp, esp
    push esi
    
    mov ecx, [ebp + 8]     ; Get argument count
    lea esi, [ebp + 12]    ; Point to first argument
    xor eax, eax           ; Initialize sum
    
sum_loop:
    add eax, [esi]         ; Add current argument
    add esi, 4             ; Move to next argument
    loop sum_loop          ; Continue for all arguments
    
    pop esi                ; Restore registers
    pop ebp                ; Function epilogue
    ret
```

### Function Return Multiple Values
```assembly
section .data
    dividend dd 17
    divisor dd 5
    quotient dd 0
    remainder dd 0

section .text
    global _start

_start:
    push remainder         ; Address for remainder result
    push quotient          ; Address for quotient result
    push dword [divisor]   ; Divisor value
    push dword [dividend]  ; Dividend value
    call divmod            ; Call division function
    add esp, 16            ; Clean up parameters
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80

divmod:
    ; Division function returning quotient and remainder
    ; Input: [EBP + 8] = dividend, [EBP + 12] = divisor
    ;        [EBP + 16] = quotient address, [EBP + 20] = remainder address
    
    push ebp               ; Function prologue
    mov ebp, esp
    
    mov eax, [ebp + 8]     ; Get dividend
    xor edx, edx           ; Clear remainder
    div dword [ebp + 12]   ; Divide by divisor
    
    ; Store results
    mov ebx, [ebp + 16]    ; Get quotient address
    mov [ebx], eax         ; Store quotient
    
    mov ebx, [ebp + 20]    ; Get remainder address
    mov [ebx], edx         ; Store remainder
    
    pop ebp                ; Function epilogue
    ret
```

## Practice Exercises

1. **Math Library**: Create functions for power, square root, GCD
2. **String Library**: Implement strcat, strcmp, strstr functions
3. **Array Functions**: Create sort, search, reverse functions
4. **Calculator**: Build a calculator using function calls

## Calling Convention Summary

### Register Usage Convention
- **EAX**: Return value, scratch register
- **EBX**: Preserved across calls
- **ECX**: Scratch register, loop counter
- **EDX**: Scratch register, used in multiplication/division
- **ESI/EDI**: Preserved across calls, string operations
- **EBP**: Frame pointer, preserved across calls
- **ESP**: Stack pointer, managed by call/ret

### Stack Management
- Parameters pushed right-to-left
- Caller cleans up stack (in examples above)
- Return address pushed by CALL instruction
- Local variables allocated by subtracting from ESP

---

**Next Module**: [System Calls](10-system-calls.md)
