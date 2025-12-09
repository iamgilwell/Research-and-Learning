# Module 3: Basic Instructions

## Data Movement Instructions

### MOV - Move Data
```assembly
mov destination, source

mov eax, 42        ; Load immediate value
mov eax, ebx       ; Copy register to register  
mov eax, [num]     ; Load from memory
mov [result], eax  ; Store to memory
```

### PUSH/POP - Stack Operations
```assembly
push eax          ; Put EAX on stack
push 42           ; Put immediate value on stack
pop ebx           ; Take top value, put in EBX
```

## Arithmetic Instructions

### Basic Math
```assembly
add eax, 5        ; EAX = EAX + 5
sub eax, 3        ; EAX = EAX - 3  
inc eax           ; EAX = EAX + 1
dec eax           ; EAX = EAX - 1
neg eax           ; EAX = -EAX
```

### Multiplication and Division
```assembly
; Multiplication (unsigned)
mov eax, 10
mov ebx, 5
mul ebx           ; EAX = EAX * EBX (result in EAX)

; Division (unsigned)  
mov eax, 20
mov ebx, 4
xor edx, edx      ; Clear EDX (required for division)
div ebx           ; EAX = EAX / EBX, EDX = remainder
```

## Comprehensive Example

**File: calculator.asm**
```assembly
section .data
    num1 dd 15
    num2 dd 4
    sum dd 0
    difference dd 0
    product dd 0
    quotient dd 0
    remainder dd 0

section .text
    global _start

_start:
    ; Load first number
    mov eax, [num1]     ; EAX = 15
    mov ebx, [num2]     ; EBX = 4
    
    ; Addition
    add eax, ebx        ; EAX = 15 + 4 = 19
    mov [sum], eax      ; Store sum
    
    ; Subtraction (reload EAX)
    mov eax, [num1]     ; EAX = 15
    sub eax, ebx        ; EAX = 15 - 4 = 11  
    mov [difference], eax
    
    ; Multiplication (reload EAX)
    mov eax, [num1]     ; EAX = 15
    mul ebx             ; EAX = 15 * 4 = 60
    mov [product], eax
    
    ; Division (reload EAX)
    mov eax, [num1]     ; EAX = 15
    xor edx, edx        ; Clear EDX for division
    div ebx             ; EAX = 15 / 4 = 3, EDX = 3
    mov [quotient], eax ; Store quotient
    mov [remainder], edx ; Store remainder
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80
```

## Logical Instructions

### Bitwise Operations
```assembly
and eax, ebx      ; Bitwise AND
or  eax, ebx      ; Bitwise OR  
xor eax, ebx      ; Bitwise XOR
not eax           ; Bitwise NOT (flip all bits)
```

### Bit Shifting
```assembly
shl eax, 2        ; Shift left 2 positions (multiply by 4)
shr eax, 1        ; Shift right 1 position (divide by 2)
```

## Practical Bit Operations

**File: bitops.asm**
```assembly
section .data
    number dd 12      ; Binary: 1100

section .text
    global _start

_start:
    mov eax, [number] ; EAX = 12 (1100 in binary)
    
    ; Double the number (shift left 1)
    shl eax, 1        ; EAX = 24 (11000 in binary)
    
    ; Check if bit 3 is set
    mov ebx, eax      ; Copy to EBX
    and ebx, 8        ; AND with 1000 (bit 3 mask)
    ; EBX will be 8 if bit 3 is set, 0 if not
    
    ; Set bit 0 (make number odd)
    or eax, 1         ; EAX = 25 (11001 in binary)
    
    ; Clear bit 4  
    and eax, 0xFFFFFFEF ; Clear bit 4 (AND with ...11101111)
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80
```

## String Instructions

### Basic String Operations
```assembly
; Move string data
mov esi, source_string  ; Source index
mov edi, dest_string    ; Destination index
mov ecx, string_length  ; Counter
rep movsb              ; Repeat move byte
```

## Instruction Reference Quick Guide

| Instruction | Purpose | Example |
|-------------|---------|---------|
| `mov` | Move data | `mov eax, 5` |
| `add` | Addition | `add eax, ebx` |
| `sub` | Subtraction | `sub eax, 10` |
| `mul` | Multiply | `mul ebx` |
| `div` | Divide | `div ebx` |
| `inc` | Increment | `inc eax` |
| `dec` | Decrement | `dec eax` |
| `and` | Bitwise AND | `and eax, 0xFF` |
| `or` | Bitwise OR | `or eax, 1` |
| `xor` | Bitwise XOR | `xor eax, eax` |
| `shl` | Shift left | `shl eax, 2` |
| `shr` | Shift right | `shr eax, 1` |

## Common Patterns

### Clear a register
```assembly
xor eax, eax      ; Faster than mov eax, 0
```

### Swap two registers (without temp)
```assembly
xor eax, ebx
xor ebx, eax  
xor eax, ebx
```

### Check if number is even
```assembly
test eax, 1       ; Test bit 0
jz is_even        ; Jump if zero (even)
```

## Practice Exercises

1. **Calculator Enhancement**: Add support for modulo operation
2. **Bit Counter**: Count number of 1 bits in a number
3. **Power of 2**: Check if a number is a power of 2

---

**Next Module**: [Data Types and Storage](04-data-types.md)
