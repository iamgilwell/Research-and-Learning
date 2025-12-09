; Solution: Exercise 4 - String Manipulation
; Performs various string operations

section .data
    original db 'hello world programming', 0
    target_char db 'o'
    
section .bss
    string_length resd 1
    char_count resd 1
    
section .text
    global _start

_start:
    ; Task 1: Calculate string length
    mov esi, original      ; Point to string
    xor ecx, ecx           ; Length counter = 0
    
length_loop:
    cmp byte [esi + ecx], 0 ; Check for null terminator
    je length_done         ; Jump if end of string
    inc ecx                ; Increment length
    jmp length_loop        ; Continue counting
    
length_done:
    mov [string_length], ecx ; Store length (22)
    
    ; Task 2: Convert to uppercase
    mov esi, original      ; Reset pointer
    
uppercase_loop:
    mov al, [esi]          ; Get current character
    test al, al            ; Check for null terminator
    jz uppercase_done      ; Jump if end of string
    
    ; Check if lowercase letter (a-z)
    cmp al, 'a'
    jb next_upper_char     ; Jump if below 'a'
    cmp al, 'z'
    ja next_upper_char     ; Jump if above 'z'
    
    ; Convert to uppercase
    sub al, 32             ; 'a' - 'A' = 32
    mov [esi], al          ; Store back
    
next_upper_char:
    inc esi                ; Next character
    jmp uppercase_loop     ; Continue
    
uppercase_done:
    ; Task 3: Count character occurrences
    mov esi, original      ; Reset pointer
    mov al, [target_char]  ; Load target character ('o')
    xor ecx, ecx           ; Count = 0
    
count_loop:
    mov bl, [esi]          ; Get current character
    test bl, bl            ; Check for null terminator
    jz count_done          ; Jump if end of string
    
    cmp bl, al             ; Compare with target
    jne next_count_char    ; Jump if not equal
    inc ecx                ; Increment count if match
    
next_count_char:
    inc esi                ; Next character
    jmp count_loop         ; Continue
    
count_done:
    mov [char_count], ecx  ; Store count (2 for 'o')
    
    ; Task 4: Reverse the string
    ; First, find string length again (it may have changed)
    mov esi, original
    xor ecx, ecx
    
find_end:
    cmp byte [esi + ecx], 0
    je reverse_setup
    inc ecx
    jmp find_end
    
reverse_setup:
    ; ECX = string length
    mov esi, original      ; Start of string
    lea edi, [original + ecx - 1] ; End of string
    
reverse_loop:
    cmp esi, edi           ; Check if pointers crossed
    jge reverse_done       ; Done if start >= end
    
    ; Swap characters
    mov al, [esi]          ; Get start character
    mov bl, [edi]          ; Get end character
    mov [esi], bl          ; Put end char at start
    mov [edi], al          ; Put start char at end
    
    inc esi                ; Move start forward
    dec edi                ; Move end backward
    jmp reverse_loop       ; Continue swapping
    
reverse_done:
    ; String is now reversed: "GNIMMARGORP DLROW OLLEH"
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80

; Expected results:
; string_length = 22
; After uppercase: "HELLO WORLD PROGRAMMING"  
; char_count = 2 (count of 'o' in original)
; After reverse: "GNIMMARGORP DLROW OLLEH"
