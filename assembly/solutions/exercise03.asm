; Solution: Exercise 3 - Array Processing
; Finds statistics for an array of integers

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
    ; Initialize with first element
    mov esi, numbers       ; Point to array
    mov eax, [esi]         ; Load first element
    mov [max_val], eax     ; Initialize max
    mov [min_val], eax     ; Initialize min
    
    ; Process all elements
    mov ecx, count         ; Loop counter
    xor edx, edx           ; Clear sum accumulator
    
process_loop:
    mov eax, [esi]         ; Load current element
    
    ; Add to sum
    add edx, eax
    
    ; Check if new maximum
    cmp eax, [max_val]
    jle check_min          ; Jump if not greater
    mov [max_val], eax     ; Update maximum
    
check_min:
    ; Check if new minimum
    cmp eax, [min_val]
    jge check_even_odd     ; Jump if not less
    mov [min_val], eax     ; Update minimum
    
check_even_odd:
    ; Check if even or odd
    test eax, 1            ; Test bit 0
    jnz is_odd             ; Jump if bit 0 is set (odd)
    
    ; Number is even
    inc dword [even_count]
    jmp next_element
    
is_odd:
    ; Number is odd
    inc dword [odd_count]
    
next_element:
    add esi, 4             ; Move to next element (4 bytes)
    loop process_loop      ; Continue for all elements
    
    ; Store final sum
    mov [total_sum], edx
    
    ; Bonus: Calculate average
    mov eax, edx           ; Load sum
    mov ebx, count         ; Load count
    xor edx, edx           ; Clear remainder
    div ebx                ; EAX = average
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80

; Results for array [45, 23, 67, 12, 89, 34, 56, 78, 91, 25]:
; max_val = 91
; min_val = 12  
; total_sum = 520
; even_count = 4 (12, 34, 56, 78)
; odd_count = 6 (45, 23, 67, 89, 91, 25)
