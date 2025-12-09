# Exercise 3: Array Processing

## Objective
Create a program that processes an array of integers to find statistics.

## Requirements
1. Create an array of at least 10 integers
2. Find the maximum value in the array
3. Find the minimum value in the array
4. Calculate the sum of all elements
5. Count how many elements are even vs odd

## Template
```assembly
section .data
    numbers dd 45, 23, 67, 12, 89, 34, 56, 78, 91, 25
    count equ ($ - numbers) / 4
    
    max_val dd 0
    min_val dd 0xFFFFFFFF
    total_sum dd 0
    even_count dd 0
    odd_count dd 0

section .text
    global _start

_start:
    ; Your code here
    ; Process the array to find all statistics
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80
```

## Expected Results
For the given array [45, 23, 67, 12, 89, 34, 56, 78, 91, 25]:
- Maximum: 91
- Minimum: 12
- Sum: 520
- Even count: 4 (12, 34, 56, 78)
- Odd count: 6 (45, 23, 67, 89, 91, 25)

## Hints
- Use a loop to iterate through the array
- Use CMP instruction to find max/min values
- Use TEST instruction to check if a number is even (test with 1)
- Keep running totals as you process each element

## Bonus Challenges
1. Calculate the average (sum ÷ count)
2. Find the second largest number
3. Sort the array in ascending order

## Debugging
Use GDB to verify your results:
```bash
./tools/build.sh exercise03.asm debug
./tools/debug_helper.sh exercise03
(gdb) break _start
(gdb) run
(gdb) x/wd &max_val    # Check maximum value
(gdb) x/wd &min_val    # Check minimum value
(gdb) x/wd &total_sum  # Check sum
```

## Solution
Check `solutions/exercise03.asm` after attempting the exercise.
