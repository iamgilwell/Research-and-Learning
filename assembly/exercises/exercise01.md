# Exercise 1: Your First Assembly Program

## Objective
Create a simple assembly program that displays your name.

## Requirements
1. Create a program that prints "Hello, [Your Name]!" to the console
2. Use proper program structure with .data and .text sections
3. Exit cleanly with status code 0

## Template
```assembly
section .data
    ; Define your message here
    
section .text
    global _start

_start:
    ; Your code here
    
    ; Exit program
    mov eax, 1
    mov ebx, 0
    int 0x80
```

## Building Instructions
```bash
nasm -f elf32 exercise01.asm -o exercise01.o
ld -m elf_i386 exercise01.o -o exercise01
./exercise01
```

## Expected Output
```
Hello, John!
```

## Hints
- Use `db` to define your string
- Don't forget the newline character (0xA)
- Calculate string length with `equ $ - msg`
- Use system call 4 (sys_write) to print

## Bonus Challenge
Modify the program to also print your age on a second line.

## Solution
Check `solutions/exercise01.asm` after attempting the exercise.
