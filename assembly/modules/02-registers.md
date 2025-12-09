# Module 2: CPU Registers and Memory

## What are Registers?

Registers are small, fast storage locations built directly into the CPU. Think of them as the CPU's workspace.

## x86 General Purpose Registers

### 32-bit Registers (EAX, EBX, ECX, EDX)

```
EAX (Accumulator)    - Main register for arithmetic and return values
EBX (Base)           - Often holds memory addresses  
ECX (Counter)        - Used for loops and string operations
EDX (Data)           - Used with EAX for multiplication/division
```

### Register Subdivisions

Each 32-bit register can be accessed in smaller parts:

```
EAX (32-bit): [--------EAX--------]
AX  (16-bit):          [----AX----]
AH  (8-bit):           [AH--]
AL  (8-bit):               [--AL]
```

## Memory vs Registers

**Registers**: Fast, limited (only 8 general purpose)
**Memory**: Slower, virtually unlimited

```assembly
mov eax, 42        ; Put 42 directly in register (fast)
mov [address], 42  ; Put 42 in memory location (slower)
```

## Practical Example

**File: registers.asm**
```assembly
section .data
    num1 dd 15        ; 32-bit number
    num2 dd 25        ; 32-bit number
    result dd 0       ; Space for result

section .text
    global _start

_start:
    ; Load first number into EAX
    mov eax, [num1]   ; EAX = 15
    
    ; Add second number
    add eax, [num2]   ; EAX = 15 + 25 = 40
    
    ; Store result in memory
    mov [result], eax ; result = 40
    
    ; Exit program
    mov eax, 1        ; sys_exit
    mov ebx, 0        ; exit status
    int 0x80
```

## Memory Addressing Modes

### Direct Addressing
```assembly
mov eax, [num1]     ; Get value at address 'num1'
```

### Immediate Addressing  
```assembly
mov eax, 42         ; Put literal value 42 in EAX
```

### Register Addressing
```assembly
mov eax, ebx        ; Copy EBX value to EAX
```

### Indirect Addressing
```assembly
mov eax, [ebx]      ; Get value at address stored in EBX
```

## Working with Different Sizes

```assembly
section .data
    byte_val  db 255      ; 8-bit value
    word_val  dw 65535    ; 16-bit value  
    dword_val dd 4000000  ; 32-bit value

section .text
    global _start

_start:
    ; 8-bit operations
    mov al, [byte_val]    ; Load byte into AL
    
    ; 16-bit operations  
    mov ax, [word_val]    ; Load word into AX
    
    ; 32-bit operations
    mov eax, [dword_val]  ; Load dword into EAX
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80
```

## Register Usage Conventions

**EAX**: Return values, accumulator for math
**EBX**: Base pointer, general storage
**ECX**: Loop counter, string operations
**EDX**: Data register, used with EAX for large operations

## Debugging with GDB

```bash
# Compile with debug info
nasm -f elf32 -g registers.asm -o registers.o
ld -m elf_i386 registers.o -o registers

# Debug
gdb ./registers
(gdb) break _start
(gdb) run
(gdb) info registers    # Show all register values
(gdb) stepi            # Step one instruction
```

## Common Mistakes

1. **Forgetting brackets**: `mov eax, num1` vs `mov eax, [num1]`
2. **Size mismatches**: Using 32-bit register with 8-bit data
3. **Overwriting registers**: Losing important values

## Practice Exercise

Create a program that:
1. Loads two numbers from memory
2. Multiplies them using registers
3. Stores the result back to memory

**Hint**: Use `mul` instruction with EAX and another register.

---

**Next Module**: [Basic Instructions](03-basic-instructions.md)
