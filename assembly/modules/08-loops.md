# Module 8: Loops and Iteration

## Loop Fundamentals

Loops in assembly are implemented using labels and conditional jumps. There are several patterns and specialized instructions.

## Basic Loop Patterns

### Simple Counter Loop
```assembly
section .data
    counter dd 0
    max_count dd 10

section .text
    global _start

_start:
    mov ecx, 0             ; Initialize counter
    
loop_start:
    ; Loop body - process current iteration
    inc ecx                ; Increment counter
    
    cmp ecx, [max_count]   ; Compare with maximum
    jl loop_start          ; Jump if less than max
    
    ; Loop finished
    mov eax, 1
    mov ebx, 0
    int 0x80
```

### Countdown Loop
```assembly
section .text
    global _start

_start:
    mov ecx, 10            ; Start from 10
    
countdown:
    ; Loop body - ECX contains current value
    
    dec ecx                ; Decrement counter
    jnz countdown          ; Jump if not zero
    
    ; Loop finished when ECX reaches 0
    mov eax, 1
    mov ebx, 0
    int 0x80
```

## LOOP Instruction

The `LOOP` instruction automatically decrements ECX and jumps if ECX ≠ 0.

```assembly
section .data
    array dd 1, 2, 3, 4, 5
    sum dd 0

section .text
    global _start

_start:
    mov esi, array         ; Point to array
    mov eax, 0             ; Initialize sum
    mov ecx, 5             ; Loop counter (5 elements)
    
sum_loop:
    add eax, [esi]         ; Add current element to sum
    add esi, 4             ; Move to next element (4 bytes)
    loop sum_loop          ; Decrement ECX and loop if not zero
    
    mov [sum], eax         ; Store final sum
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80
```

## Array Processing Loops

### Linear Search
```assembly
section .data
    numbers dd 10, 25, 7, 42, 15, 33, 8
    count equ ($ - numbers) / 4
    target dd 42
    found_index dd -1      ; -1 means not found

section .text
    global _start

_start:
    mov esi, numbers       ; Point to array start
    mov eax, [target]      ; Load target value
    mov ecx, count         ; Loop counter
    mov edx, 0             ; Current index
    
search_loop:
    cmp eax, [esi]         ; Compare target with current element
    je found_target        ; Jump if found
    
    add esi, 4             ; Move to next element
    inc edx                ; Increment index
    loop search_loop       ; Continue if more elements
    
    ; Not found - EDX will be count, found_index stays -1
    jmp search_done
    
found_target:
    mov [found_index], edx ; Store found index
    
search_done:
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80
```

### Bubble Sort
```assembly
section .data
    array dd 64, 34, 25, 12, 22, 11, 90
    size equ ($ - array) / 4

section .text
    global _start

_start:
    ; Outer loop - number of passes
    mov ecx, size - 1      ; Need size-1 passes
    
outer_loop:
    push ecx               ; Save outer counter
    mov esi, array         ; Reset to array start
    mov edx, ecx           ; Inner loop counter
    
inner_loop:
    mov eax, [esi]         ; Load current element
    mov ebx, [esi + 4]     ; Load next element
    
    cmp eax, ebx           ; Compare current with next
    jle no_swap            ; Jump if already in order
    
    ; Swap elements
    mov [esi], ebx         ; Store next in current position
    mov [esi + 4], eax     ; Store current in next position
    
no_swap:
    add esi, 4             ; Move to next pair
    dec edx                ; Decrement inner counter
    jnz inner_loop         ; Continue inner loop
    
    pop ecx                ; Restore outer counter
    loop outer_loop        ; Continue outer loop
    
    ; Array is now sorted
    mov eax, 1
    mov ebx, 0
    int 0x80
```

## String Processing Loops

### Character Counting
```assembly
section .data
    text db 'Count the letter e in this sentence', 0
    target_char db 'e'
    char_count dd 0

section .text
    global _start

_start:
    mov esi, text          ; Point to string
    mov al, [target_char]  ; Load target character
    mov ecx, 0             ; Character count
    
count_loop:
    mov bl, [esi]          ; Load current character
    test bl, bl            ; Check for null terminator
    jz count_done          ; Jump if end of string
    
    cmp bl, al             ; Compare with target
    jne next_char          ; Jump if not equal
    inc ecx                ; Increment count if match
    
next_char:
    inc esi                ; Move to next character
    jmp count_loop         ; Continue loop
    
count_done:
    mov [char_count], ecx  ; Store final count
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80
```

### String Reversal
```assembly
section .data
    original db 'reverse this string', 0
    
section .bss
    reversed resb 50       ; Buffer for reversed string

section .text
    global _start

_start:
    ; Find string length
    mov esi, original
    mov ecx, 0
    
length_loop:
    cmp byte [esi + ecx], 0
    je length_found
    inc ecx
    jmp length_loop
    
length_found:
    ; ECX = string length
    ; Copy characters in reverse order
    mov esi, original      ; Source (start of original)
    lea edi, [original + ecx - 1] ; Source (end of original)
    mov ebx, reversed      ; Destination
    
reverse_loop:
    mov al, [edi]          ; Get character from end
    mov [ebx], al          ; Store in destination
    dec edi                ; Move backward in source
    inc ebx                ; Move forward in destination
    loop reverse_loop      ; ECX automatically decrements
    
    mov byte [ebx], 0      ; Add null terminator
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80
```

## Nested Loops

### Matrix Operations (2D Array)
```assembly
section .data
    ; 3x3 matrix
    matrix dd 1, 2, 3, 4, 5, 6, 7, 8, 9
    ROWS equ 3
    COLS equ 3
    sum dd 0

section .text
    global _start

_start:
    mov eax, 0             ; Initialize sum
    mov ecx, ROWS          ; Outer loop counter (rows)
    mov esi, matrix        ; Point to matrix start
    
row_loop:
    push ecx               ; Save row counter
    mov ecx, COLS          ; Inner loop counter (columns)
    
col_loop:
    add eax, [esi]         ; Add current element to sum
    add esi, 4             ; Move to next element
    loop col_loop          ; Process all columns in row
    
    pop ecx                ; Restore row counter
    loop row_loop          ; Process all rows
    
    mov [sum], eax         ; Store final sum
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80
```

### Multiplication Table
```assembly
section .data
    newline db 0xA, 0      ; Newline character

section .bss
    result resb 10         ; Buffer for number conversion

section .text
    global _start

_start:
    mov ecx, 1             ; Outer loop: multiplicand (1-10)
    
outer_mult:
    push ecx               ; Save outer counter
    mov edx, 1             ; Inner loop: multiplier (1-10)
    
inner_mult:
    ; Calculate ecx * edx
    mov eax, ecx
    imul eax, edx          ; EAX = ECX * EDX
    
    ; Convert result to string and print (simplified)
    ; In real implementation, you'd convert EAX to ASCII
    
    inc edx                ; Next multiplier
    cmp edx, 11            ; Check if done with row
    jl inner_mult          ; Continue inner loop
    
    ; Print newline after each row
    mov eax, 4             ; sys_write
    mov ebx, 1             ; stdout
    mov ecx, newline       ; newline string
    mov edx, 1             ; length
    int 0x80
    
    pop ecx                ; Restore outer counter
    inc ecx                ; Next multiplicand
    cmp ecx, 11            ; Check if done
    jl outer_mult          ; Continue outer loop
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80
```

## Loop Control

### Break (Early Exit)
```assembly
section .data
    numbers dd 5, 10, 15, 0, 25, 30  ; 0 is our "break" condition
    
section .text
    global _start

_start:
    mov esi, numbers       ; Point to array
    mov ecx, 6             ; Maximum iterations
    
process_loop:
    mov eax, [esi]         ; Load current number
    
    test eax, eax          ; Check if zero
    jz loop_break          ; Break if zero found
    
    ; Process non-zero number here
    
    add esi, 4             ; Next element
    loop process_loop      ; Continue loop
    
loop_break:
    ; Exited loop early or normally
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80
```

### Continue (Skip Iteration)
```assembly
section .data
    numbers dd 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
    even_sum dd 0

section .text
    global _start

_start:
    mov esi, numbers       ; Point to array
    mov ecx, 10            ; Loop counter
    mov eax, 0             ; Sum accumulator
    
sum_evens:
    mov ebx, [esi]         ; Load current number
    
    test ebx, 1            ; Check if odd (bit 0 set)
    jnz skip_odd           ; Skip if odd
    
    add eax, ebx           ; Add even number to sum
    
skip_odd:
    add esi, 4             ; Next element
    loop sum_evens         ; Continue loop
    
    mov [even_sum], eax    ; Store result
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80
```

## Infinite Loops and Loop Control

### Infinite Loop with Break Condition
```assembly
section .data
    counter dd 0
    max_iterations dd 1000

section .text
    global _start

_start:
infinite_loop:
    ; Increment counter
    inc dword [counter]
    
    ; Check break condition
    mov eax, [counter]
    cmp eax, [max_iterations]
    jge loop_exit          ; Break if counter >= max
    
    ; Loop body here
    
    jmp infinite_loop      ; Continue forever (until break)
    
loop_exit:
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80
```

## Performance Optimizations

### Loop Unrolling
```assembly
section .data
    array dd 1, 2, 3, 4, 5, 6, 7, 8
    sum dd 0

section .text
    global _start

_start:
    mov esi, array         ; Point to array
    mov eax, 0             ; Initialize sum
    mov ecx, 2             ; Process 4 elements per iteration
    
unrolled_loop:
    ; Process 4 elements at once
    add eax, [esi]         ; Element 0
    add eax, [esi + 4]     ; Element 1
    add eax, [esi + 8]     ; Element 2
    add eax, [esi + 12]    ; Element 3
    
    add esi, 16            ; Move to next group of 4
    loop unrolled_loop     ; Process next 4 elements
    
    mov [sum], eax         ; Store result
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80
```

## Practice Exercises

1. **Prime Number Generator**: Find all prime numbers up to N
2. **Fibonacci Sequence**: Generate first N Fibonacci numbers
3. **Binary Search**: Implement binary search on sorted array
4. **String Pattern Matching**: Find all occurrences of substring in text

## Loop Instruction Variants

| Instruction | Description | Condition |
|-------------|-------------|-----------|
| `loop` | Loop while ECX ≠ 0 | ECX ≠ 0 |
| `loope/loopz` | Loop while equal/zero | ECX ≠ 0 and ZF = 1 |
| `loopne/loopnz` | Loop while not equal/not zero | ECX ≠ 0 and ZF = 0 |

---

**Next Module**: [Functions and Procedures](09-functions.md)
