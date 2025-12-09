# Exercise 2: Register Manipulation

## Objective
Practice moving data between registers and memory.

## Requirements
1. Load two numbers from memory into registers
2. Swap their values using only registers (no temporary memory)
3. Store the swapped values back to memory
4. Use the XOR swap technique

## Template
```assembly
section .data
    num1 dd 42
    num2 dd 17
    
section .text
    global _start

_start:
    ; Load numbers into registers
    mov eax, [num1]
    mov ebx, [num2]
    
    ; Swap using XOR technique
    ; Your code here
    
    ; Store swapped values back
    mov [num1], eax
    mov [num2], ebx
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80
```

## XOR Swap Algorithm
The XOR swap works because:
- A XOR A = 0
- A XOR 0 = A
- XOR is commutative: A XOR B = B XOR A

## Verification
Use GDB to verify the swap worked:
```bash
gdb ./exercise02
(gdb) break _start
(gdb) run
(gdb) x/2wd &num1    # Check initial values
(gdb) continue
(gdb) x/2wd &num1    # Check final values
```

## Expected Result
- num1 should contain 17
- num2 should contain 42

## Bonus Challenge
Implement the swap using only 2 registers instead of 3.

## Solution
Check `solutions/exercise02.asm` after attempting the exercise.
