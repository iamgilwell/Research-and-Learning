# Module 5: Memory Addressing

## Addressing Modes

Assembly provides multiple ways to specify memory locations. Understanding these is crucial for efficient programming.

### 1. Immediate Addressing
```assembly
mov eax, 42         ; Load literal value 42
add ebx, 100        ; Add literal 100 to EBX
```

### 2. Register Addressing
```assembly
mov eax, ebx        ; Copy EBX to EAX
add ecx, edx        ; Add EDX to ECX
```

### 3. Direct Addressing
```assembly
section .data
    number dd 1000

section .text
    mov eax, [number]   ; Load value at 'number' address
    mov [number], ebx   ; Store EBX at 'number' address
```

### 4. Indirect Addressing
```assembly
mov eax, [ebx]      ; Load value at address stored in EBX
mov [ecx], eax      ; Store EAX at address stored in ECX
```

### 5. Indexed Addressing
```assembly
section .data
    array dd 10, 20, 30, 40, 50

section .text
    mov esi, array      ; Point to array start
    mov eax, [esi + 8]  ; Get 3rd element (30) - 8 = 2*4 bytes
    mov ebx, [esi + 12] ; Get 4th element (40) - 12 = 3*4 bytes
```

### 6. Base + Index Addressing
```assembly
mov eax, [ebx + esi]        ; Address = EBX + ESI
mov eax, [ebx + esi + 4]    ; Address = EBX + ESI + 4
mov eax, [ebx + esi*2]      ; Address = EBX + (ESI * 2)
mov eax, [ebx + esi*4 + 8]  ; Address = EBX + (ESI * 4) + 8
```

## Scale Factors

Scale factors multiply index registers for array access:

```assembly
section .data
    bytes   db 1, 2, 3, 4, 5       ; 1 byte each
    words   dw 100, 200, 300       ; 2 bytes each  
    dwords  dd 1000, 2000, 3000    ; 4 bytes each

section .text
    mov esi, 2                      ; Index = 2
    
    ; Byte array access
    mov al, [bytes + esi]           ; Get bytes[2] = 3
    
    ; Word array access  
    mov ax, [words + esi*2]         ; Get words[2] = 300
    
    ; Dword array access
    mov eax, [dwords + esi*4]       ; Get dwords[2] = 3000
```

## Comprehensive Addressing Example

**File: addressing.asm**
```assembly
section .data
    ; 2D array simulation: 3x3 matrix
    matrix dd 1, 2, 3, 4, 5, 6, 7, 8, 9
    ROWS equ 3
    COLS equ 3
    
    ; String array
    strings dd str1, str2, str3
    str1 db 'First', 0
    str2 db 'Second', 0  
    str3 db 'Third', 0

section .text
    global _start

_start:
    ; Direct addressing
    mov eax, [matrix]           ; Get matrix[0][0] = 1
    
    ; Indexed addressing - get matrix[1][2] 
    ; Formula: address = base + (row * COLS + col) * element_size
    mov ebx, 1                  ; Row 1
    imul ebx, COLS              ; EBX = 1 * 3 = 3
    add ebx, 2                  ; EBX = 3 + 2 = 5 (column 2)
    mov eax, [matrix + ebx*4]   ; Get matrix[1][2] = 6
    
    ; Base + Index addressing for string array
    mov esi, 1                  ; Want string index 1
    mov ebx, strings            ; Base address of pointer array
    mov eax, [ebx + esi*4]      ; Get pointer to strings[1]
    mov al, [eax]               ; Get first character 'S'
    
    ; Complex addressing - array of structures
    ; Each person: name(16 bytes) + age(4 bytes) = 20 bytes total
    mov edi, 2                  ; Want person index 2
    imul edi, 20                ; EDI = 2 * 20 = 40 (offset to person 2)
    ; mov eax, [people + edi + 16]  ; Get age of person 2
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80
```

## Stack Operations

The stack uses ESP (Stack Pointer) for addressing:

```assembly
section .text
    global _start

_start:
    ; Push values onto stack
    push 100                ; ESP -= 4, [ESP] = 100
    push 200                ; ESP -= 4, [ESP] = 200
    push 300                ; ESP -= 4, [ESP] = 300
    
    ; Access stack without popping
    mov eax, [esp]          ; Get top value (300)
    mov ebx, [esp + 4]      ; Get second value (200)
    mov ecx, [esp + 8]      ; Get third value (100)
    
    ; Pop values from stack
    pop edx                 ; EDX = 300, ESP += 4
    pop esi                 ; ESI = 200, ESP += 4
    pop edi                 ; EDI = 100, ESP += 4
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80
```

## Pointer Arithmetic

### Single Indirection
```assembly
section .data
    value dd 42
    ptr   dd value          ; Pointer to value

section .text
    mov eax, [ptr]          ; Get address stored in ptr
    mov ebx, [eax]          ; Get value at that address (42)
    
    ; Or in one step
    mov ecx, ptr
    mov edx, [ecx]          ; Get address
    mov edx, [edx]          ; Get value (42)
```

### Double Indirection
```assembly
section .data
    value   dd 100
    ptr1    dd value        ; Points to value
    ptr2    dd ptr1         ; Points to ptr1

section .text
    mov eax, [ptr2]         ; Get address of ptr1
    mov eax, [eax]          ; Get address of value  
    mov eax, [eax]          ; Get actual value (100)
```

## Memory Access Patterns

### Sequential Access
```assembly
section .data
    buffer db 100 dup(0)    ; 100-byte buffer

section .text
    mov esi, buffer         ; Start of buffer
    mov ecx, 100            ; Counter
    
fill_loop:
    mov byte [esi], 0xFF    ; Fill with 0xFF
    inc esi                 ; Next byte
    loop fill_loop          ; Decrement ECX and loop if not zero
```

### Strided Access (Every Nth Element)
```assembly
section .data
    array dd 1,2,3,4,5,6,7,8,9,10

section .text
    mov esi, array          ; Start of array
    mov ecx, 5              ; Process 5 elements
    
stride_loop:
    mov eax, [esi]          ; Get current element
    ; Process eax here
    add esi, 8              ; Skip to every other element (stride=2)
    loop stride_loop
```

## Effective Address Calculation

### LEA Instruction (Load Effective Address)
```assembly
section .data
    array dd 10, 20, 30, 40

section .text
    mov esi, 2              ; Index
    lea eax, [array + esi*4] ; Calculate address, don't load value
    mov ebx, [eax]          ; Now load the value (30)
    
    ; LEA for arithmetic (clever trick)
    mov eax, 5
    lea ebx, [eax + eax*2]  ; EBX = 5 + 5*2 = 15 (multiply by 3)
    lea ecx, [eax*8 + 7]    ; ECX = 5*8 + 7 = 47
```

## Memory Bounds and Safety

### Buffer Overflow Prevention
```assembly
section .data
    buffer db 10 dup(0)     ; 10-byte buffer
    BUFFER_SIZE equ 10

section .text
    mov esi, buffer         ; Buffer start
    mov ecx, 0              ; Index
    
safe_write:
    cmp ecx, BUFFER_SIZE    ; Check bounds
    jge bounds_error        ; Jump if index >= size
    
    mov byte [esi + ecx], 'A' ; Safe write
    inc ecx
    jmp safe_write
    
bounds_error:
    ; Handle error
    mov eax, 1
    mov ebx, 1              ; Exit with error code
    int 0x80
```

## Advanced Addressing Techniques

### Function Parameter Access
```assembly
; Function with parameters pushed on stack
my_function:
    push ebp                ; Save old base pointer
    mov ebp, esp            ; Set up new base pointer
    
    ; Parameters are at positive offsets from EBP
    mov eax, [ebp + 8]      ; First parameter
    mov ebx, [ebp + 12]     ; Second parameter
    mov ecx, [ebp + 16]     ; Third parameter
    
    ; Local variables at negative offsets
    sub esp, 8              ; Reserve space for 2 local variables
    mov dword [ebp - 4], 0  ; First local variable
    mov dword [ebp - 8], 0  ; Second local variable
    
    ; Function body here
    
    mov esp, ebp            ; Restore stack pointer
    pop ebp                 ; Restore base pointer
    ret                     ; Return to caller
```

## Practice Exercises

1. **Matrix Access**: Implement 2D array access with row/column indexing
2. **Linked List**: Create and traverse a simple linked list structure
3. **String Array**: Access strings in an array of string pointers
4. **Stack Calculator**: Use stack addressing for arithmetic operations

## Performance Considerations

- **Cache Locality**: Sequential access is faster than random access
- **Alignment**: Aligned memory access is more efficient
- **Addressing Complexity**: Simple addressing modes are faster

---

**Next Module**: [String Operations](06-strings.md)
