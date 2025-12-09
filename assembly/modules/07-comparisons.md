# Module 7: Comparisons and Flags

## CPU Flags Register

The FLAGS register contains status bits that are automatically set by arithmetic and logic operations.

### Key Flags
```
Bit  Flag  Name           Purpose
0    CF    Carry Flag     Set on unsigned overflow
2    PF    Parity Flag    Set if result has even number of 1 bits
6    ZF    Zero Flag      Set if result is zero
7    SF    Sign Flag      Set if result is negative (MSB = 1)
11   OF    Overflow Flag  Set on signed overflow
```

## Comparison Instructions

### CMP - Compare
```assembly
cmp operand1, operand2    ; Performs operand1 - operand2 (sets flags)

; Examples:
cmp eax, 10              ; Compare EAX with 10
cmp [number], ebx        ; Compare memory value with EBX
cmp byte [buffer], 'A'   ; Compare byte with character
```

### TEST - Bitwise Test
```assembly
test operand1, operand2   ; Performs operand1 & operand2 (sets flags)

; Examples:
test eax, eax            ; Check if EAX is zero
test eax, 1              ; Check if bit 0 is set
test eax, 0x80000000     ; Check if bit 31 is set (sign bit)
```

## Conditional Jumps

### Unsigned Comparisons
```assembly
section .data
    num1 dd 10
    num2 dd 20

section .text
    global _start

_start:
    mov eax, [num1]        ; EAX = 10
    cmp eax, [num2]        ; Compare 10 with 20
    
    je equal               ; Jump if Equal (ZF = 1)
    jne not_equal          ; Jump if Not Equal (ZF = 0)
    ja above               ; Jump if Above (CF = 0 and ZF = 0)
    jae above_equal        ; Jump if Above or Equal (CF = 0)
    jb below               ; Jump if Below (CF = 1)
    jbe below_equal        ; Jump if Below or Equal (CF = 1 or ZF = 1)
    
not_equal:
    ; Handle not equal case
    jmp done
    
equal:
    ; Handle equal case
    jmp done
    
above:
    ; Handle above case
    jmp done
    
below:
    ; Handle below case (this will execute since 10 < 20)
    
done:
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80
```

### Signed Comparisons
```assembly
section .data
    signed_num1 dd -5
    signed_num2 dd 10

section .text
    global _start

_start:
    mov eax, [signed_num1] ; EAX = -5
    cmp eax, [signed_num2] ; Compare -5 with 10
    
    jg greater             ; Jump if Greater (signed)
    jge greater_equal      ; Jump if Greater or Equal (signed)
    jl less                ; Jump if Less (signed)
    jle less_equal         ; Jump if Less or Equal (signed)
    
less:
    ; This will execute since -5 < 10
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80
```

## Flag Testing

### Zero Flag Examples
```assembly
section .text
    global _start

_start:
    ; Test if register is zero
    mov eax, 0
    test eax, eax          ; Sets ZF if EAX is zero
    jz is_zero             ; Jump if zero
    
    ; Test if subtraction results in zero
    mov eax, 10
    mov ebx, 10
    sub eax, ebx           ; EAX = 0, sets ZF
    jz values_equal        ; Jump if result is zero
    
is_zero:
    ; Handle zero case
    
values_equal:
    ; Handle equal values
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80
```

### Carry Flag Examples
```assembly
section .text
    global _start

_start:
    ; Unsigned overflow detection
    mov eax, 0xFFFFFFFF    ; Maximum 32-bit unsigned value
    add eax, 1             ; This will set CF (carry)
    jc overflow_occurred   ; Jump if carry flag set
    
    ; Bit testing with carry
    mov eax, 0x80000000    ; Set bit 31
    shl eax, 1             ; Shift left, bit 31 goes to carry
    jc bit31_was_set       ; Jump if carry (bit 31 was 1)
    
overflow_occurred:
    ; Handle overflow
    
bit31_was_set:
    ; Handle bit 31 case
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80
```

## Comprehensive Comparison Example

**File: comparisons.asm**
```assembly
section .data
    numbers dd 15, 10, 15, 25, 5
    count equ ($ - numbers) / 4
    max_val dd 0
    min_val dd 0xFFFFFFFF

section .text
    global _start

_start:
    ; Find maximum and minimum values
    mov esi, numbers       ; Point to array
    mov ecx, count         ; Loop counter
    mov eax, [esi]         ; Load first number
    mov [max_val], eax     ; Initialize max
    mov [min_val], eax     ; Initialize min
    
find_loop:
    mov eax, [esi]         ; Load current number
    
    ; Check if greater than current max
    cmp eax, [max_val]
    jle check_min          ; Jump if not greater
    mov [max_val], eax     ; Update maximum
    
check_min:
    ; Check if less than current min
    cmp eax, [min_val]
    jge next_number        ; Jump if not less
    mov [min_val], eax     ; Update minimum
    
next_number:
    add esi, 4             ; Next number (4 bytes)
    loop find_loop         ; Decrement ECX and loop if not zero
    
    ; Results now in max_val and min_val
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80
```

## Conditional Execution Without Jumps

### CMOVcc - Conditional Move
```assembly
section .data
    a dd 10
    b dd 20
    result dd 0

section .text
    global _start

_start:
    mov eax, [a]           ; Load a
    mov ebx, [b]           ; Load b
    
    cmp eax, ebx           ; Compare a and b
    cmovg eax, ebx         ; Move b to eax if a > b (conditional move)
    
    ; EAX now contains the larger value
    mov [result], eax
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80
```

### SETcc - Set Byte on Condition
```assembly
section .data
    num1 dd 15
    num2 dd 10
    is_greater db 0

section .text
    global _start

_start:
    mov eax, [num1]        ; Load first number
    cmp eax, [num2]        ; Compare with second number
    
    setg [is_greater]      ; Set byte to 1 if greater, 0 otherwise
    
    ; is_greater now contains 1 (true) or 0 (false)
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80
```

## Multi-Precision Comparisons

### Compare 64-bit Numbers (using 32-bit registers)
```assembly
section .data
    ; 64-bit numbers stored as two 32-bit values
    num1_low  dd 0x12345678
    num1_high dd 0x9ABCDEF0
    num2_low  dd 0x11111111  
    num2_high dd 0x9ABCDEF0

section .text
    global _start

_start:
    ; Compare high parts first
    mov eax, [num1_high]
    cmp eax, [num2_high]
    ja num1_greater        ; If high part is greater, num1 > num2
    jb num2_greater        ; If high part is less, num1 < num2
    
    ; High parts are equal, compare low parts
    mov eax, [num1_low]
    cmp eax, [num2_low]
    ja num1_greater        ; num1 > num2
    jb num2_greater        ; num1 < num2
    
    ; Numbers are equal
    mov ecx, 0             ; Equal
    jmp comparison_done
    
num1_greater:
    mov ecx, 1             ; num1 > num2
    jmp comparison_done
    
num2_greater:
    mov ecx, -1            ; num1 < num2
    
comparison_done:
    ; ECX contains comparison result
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80
```

## Range Checking

### Check if Value is in Range
```assembly
section .data
    value dd 15
    min_range dd 10
    max_range dd 20
    in_range db 0

section .text
    global _start

_start:
    mov eax, [value]       ; Load value to check
    
    ; Check if value >= min_range
    cmp eax, [min_range]
    jb out_of_range        ; Jump if below minimum
    
    ; Check if value <= max_range
    cmp eax, [max_range]
    ja out_of_range        ; Jump if above maximum
    
    ; Value is in range
    mov byte [in_range], 1
    jmp range_check_done
    
out_of_range:
    mov byte [in_range], 0
    
range_check_done:
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80
```

## Floating Point Comparisons

### Basic FPU Comparisons
```assembly
section .data
    float1 dd 3.14
    float2 dd 2.71
    
section .text
    global _start

_start:
    ; Load floating point values
    fld dword [float1]     ; Load float1 onto FPU stack
    fld dword [float2]     ; Load float2 onto FPU stack
    
    ; Compare (float2 with float1)
    fcompp                 ; Compare and pop both values
    fstsw ax               ; Store FPU status word in AX
    sahf                   ; Store AH into FLAGS register
    
    ; Now can use regular conditional jumps
    ja float2_greater      ; Jump if float2 > float1
    jb float1_greater      ; Jump if float1 > float2
    je floats_equal        ; Jump if equal
    
float1_greater:
    ; Handle float1 > float2
    jmp float_done
    
float2_greater:
    ; Handle float2 > float1
    jmp float_done
    
floats_equal:
    ; Handle equal floats
    
float_done:
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80
```

## Practice Exercises

1. **Array Search**: Find if a value exists in an array
2. **Sorting**: Implement bubble sort using comparisons
3. **Grade Calculator**: Assign letter grades based on numeric scores
4. **Password Checker**: Validate password strength with multiple conditions

## Jump Instruction Reference

| Instruction | Condition | Flags |
|-------------|-----------|-------|
| `je/jz` | Equal/Zero | ZF = 1 |
| `jne/jnz` | Not Equal/Not Zero | ZF = 0 |
| `ja/jnbe` | Above (unsigned) | CF = 0 and ZF = 0 |
| `jae/jnb` | Above or Equal | CF = 0 |
| `jb/jnae` | Below (unsigned) | CF = 1 |
| `jbe/jna` | Below or Equal | CF = 1 or ZF = 1 |
| `jg/jnle` | Greater (signed) | ZF = 0 and SF = OF |
| `jge/jnl` | Greater or Equal | SF = OF |
| `jl/jnge` | Less (signed) | SF ≠ OF |
| `jle/jng` | Less or Equal | ZF = 1 or SF ≠ OF |
| `jc` | Carry | CF = 1 |
| `jnc` | No Carry | CF = 0 |
| `jo` | Overflow | OF = 1 |
| `jno` | No Overflow | OF = 0 |
| `js` | Sign (negative) | SF = 1 |
| `jns` | No Sign (positive) | SF = 0 |

---

**Next Module**: [Loops and Iteration](08-loops.md)
