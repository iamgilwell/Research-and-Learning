# Module 1: Introduction to Assembly Language

## What is Assembly Language?

Assembly language is the lowest-level programming language that humans can reasonably write. It provides direct access to CPU instructions and hardware resources.

### Key Concepts

**1. Machine Code vs Assembly**
- **Machine Code**: Binary instructions (01001000 01100101...)
- **Assembly**: Human-readable mnemonics (mov eax, 5)

**2. One-to-One Mapping**
Each assembly instruction corresponds to exactly one machine instruction.

**3. CPU Architecture**
This tutorial focuses on x86 (32-bit) assembly for Intel/AMD processors.

## Program Structure

Every assembly program has these sections:

```assembly
section .data
    ; Your data goes here (variables, constants)

section .bss  
    ; Uninitialized data (reserved space)

section .text
    global _start
_start:
    ; Your program instructions go here
```

## Your First Program

**File: hello.asm**
```assembly
section .data
    msg db 'Hello, Assembly!', 0xA    ; Our string with newline
    msg_len equ $ - msg               ; Calculate string length

section .text
    global _start

_start:
    ; Write system call
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov ecx, msg        ; message
    mov edx, msg_len    ; message length
    int 0x80            ; call kernel

    ; Exit system call
    mov eax, 1          ; sys_exit
    mov ebx, 0          ; exit status
    int 0x80            ; call kernel
```

## Building and Running

```bash
# Assemble
nasm -f elf32 hello.asm -o hello.o

# Link
ld -m elf_i386 hello.o -o hello

# Run
./hello
```

## Understanding the Code

**Section .data**
- `msg db 'Hello, Assembly!', 0xA`: Define bytes for our message
- `0xA`: Hexadecimal for newline character (10 in decimal)
- `msg_len equ $ - msg`: Calculate length ($ = current position)

**Section .text**
- `global _start`: Make _start visible to linker
- `_start:`: Entry point of program

**System Calls**
- `mov eax, 4`: Load system call number for write
- `int 0x80`: Interrupt to call kernel

## Key Takeaways

1. Assembly programs have structured sections
2. Every operation is explicit and manual
3. System calls interface with the operating system
4. Build process: assemble → link → execute

## Next Steps

- **Practice**: Build and run the hello program
- **Experiment**: Change the message text
- **Explore**: Try different exit codes (change `mov ebx, 0` to `mov ebx, 42`)

---

**Next Module**: [CPU Registers and Memory](02-registers.md)
