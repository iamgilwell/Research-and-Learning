# Module 6: String Operations

## String Representation

### Null-Terminated Strings (C-style)
```assembly
section .data
    hello db 'Hello World', 0    ; Null-terminated
    name  db 'Alice', 0
```

### Length-Prefixed Strings
```assembly
section .data
    pascal_str db 11, 'Hello World'  ; Length byte first
```

## Basic String Operations

### String Length Calculation
```assembly
section .data
    message db 'Assembly Programming', 0

section .text
    global _start

_start:
    ; Calculate string length
    mov esi, message        ; Point to string start
    xor ecx, ecx           ; Length counter = 0
    
strlen_loop:
    mov al, [esi + ecx]    ; Get character at position
    test al, al            ; Check if null terminator
    jz strlen_done         ; Jump if zero (end of string)
    inc ecx                ; Increment length
    jmp strlen_loop
    
strlen_done:
    ; ECX now contains string length
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80
```

### String Copy
```assembly
section .data
    source db 'Copy this string', 0
    
section .bss
    destination resb 50     ; Reserve 50 bytes for copy

section .text
    global _start

_start:
    ; String copy
    mov esi, source         ; Source pointer
    mov edi, destination    ; Destination pointer
    
strcpy_loop:
    mov al, [esi]          ; Get source character
    mov [edi], al          ; Store in destination
    test al, al            ; Check if null terminator
    jz strcpy_done         ; Jump if end of string
    inc esi                ; Next source character
    inc edi                ; Next destination position
    jmp strcpy_loop
    
strcpy_done:
    ; String copied successfully
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80
```

## String Instructions (x86 Specific)

### MOVSB - Move String Byte
```assembly
section .data
    source db 'Hello', 0
    
section .bss
    dest resb 10

section .text
    global _start

_start:
    ; Setup for string move
    mov esi, source         ; Source index
    mov edi, dest          ; Destination index
    mov ecx, 6             ; Number of bytes (including null)
    cld                    ; Clear direction flag (forward)
    
    rep movsb              ; Repeat move byte ECX times
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80
```

### SCASB - Scan String Byte
```assembly
section .data
    text db 'Find the letter x in this text', 0
    
section .text
    global _start

_start:
    ; Search for character 'x'
    mov edi, text          ; String to search
    mov al, 'x'            ; Character to find
    mov ecx, 100           ; Maximum characters to scan
    cld                    ; Forward direction
    
    repne scasb            ; Repeat while not equal
    
    ; Check if found
    jne not_found          ; Jump if ECX reached 0 (not found)
    
    ; Found: EDI points one past the found character
    dec edi                ; Point to the found character
    ; Process found character here
    
not_found:
    ; Character not found
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80
```

## String Comparison

### Compare Two Strings
```assembly
section .data
    str1 db 'Hello', 0
    str2 db 'Hello', 0
    str3 db 'World', 0

section .text
    global _start

_start:
    ; Compare str1 and str2
    mov esi, str1          ; First string
    mov edi, str2          ; Second string
    
strcmp_loop:
    mov al, [esi]          ; Get character from str1
    mov bl, [edi]          ; Get character from str2
    
    cmp al, bl             ; Compare characters
    jne strings_different  ; Jump if different
    
    test al, al            ; Check if end of string
    jz strings_equal       ; Both strings ended - they're equal
    
    inc esi                ; Next character in str1
    inc edi                ; Next character in str2
    jmp strcmp_loop
    
strings_equal:
    ; Strings are identical
    mov ecx, 1             ; Set result = equal
    jmp strcmp_done
    
strings_different:
    ; Strings are different
    mov ecx, 0             ; Set result = not equal
    
strcmp_done:
    ; ECX contains comparison result
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80
```

## String Manipulation

### Convert to Uppercase
```assembly
section .data
    text db 'convert this to uppercase', 0

section .text
    global _start

_start:
    mov esi, text          ; Point to string
    
uppercase_loop:
    mov al, [esi]          ; Get character
    test al, al            ; Check for end of string
    jz uppercase_done      ; Jump if null terminator
    
    ; Check if lowercase letter (a-z)
    cmp al, 'a'
    jb next_char           ; Jump if below 'a'
    cmp al, 'z'
    ja next_char           ; Jump if above 'z'
    
    ; Convert to uppercase
    sub al, 32             ; 'a' - 'A' = 32
    mov [esi], al          ; Store back
    
next_char:
    inc esi                ; Next character
    jmp uppercase_loop
    
uppercase_done:
    ; String converted to uppercase
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80
```

### Reverse String
```assembly
section .data
    text db 'reverse', 0

section .text
    global _start

_start:
    ; Find string length first
    mov esi, text
    xor ecx, ecx
    
find_length:
    cmp byte [esi + ecx], 0
    je length_found
    inc ecx
    jmp find_length
    
length_found:
    ; ECX = string length
    ; Now reverse the string
    mov esi, text          ; Start of string
    lea edi, [text + ecx - 1] ; End of string
    
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
    jmp reverse_loop
    
reverse_done:
    ; String is now reversed
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80
```

## Number to String Conversion

### Integer to ASCII
```assembly
section .data
    number dd 12345

section .bss
    buffer resb 12         ; Buffer for ASCII result

section .text
    global _start

_start:
    mov eax, [number]      ; Load number to convert
    mov edi, buffer + 11   ; Point to end of buffer
    mov byte [edi], 0      ; Null terminator
    dec edi                ; Move back one position
    
    mov ebx, 10            ; Divisor for decimal conversion
    
convert_loop:
    xor edx, edx           ; Clear remainder
    div ebx                ; Divide EAX by 10
    add dl, '0'            ; Convert remainder to ASCII
    mov [edi], dl          ; Store digit
    dec edi                ; Move to previous position
    
    test eax, eax          ; Check if quotient is zero
    jnz convert_loop       ; Continue if more digits
    
    ; EDI+1 now points to start of ASCII number
    inc edi
    
    ; Print the result (system call)
    mov eax, 4             ; sys_write
    mov ebx, 1             ; stdout
    mov ecx, edi           ; String pointer
    mov edx, buffer + 11   ; Calculate length
    sub edx, edi
    int 0x80
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80
```

## String Parsing

### Parse Command Line Arguments
```assembly
section .text
    global _start

_start:
    ; Stack layout at program start:
    ; [ESP]     = argc (argument count)
    ; [ESP+4]   = argv[0] (program name)
    ; [ESP+8]   = argv[1] (first argument)
    ; etc.
    
    mov eax, [esp]         ; Get argument count
    cmp eax, 2             ; Check if we have at least 1 argument
    jl no_args             ; Jump if less than 2 (program name + 1 arg)
    
    mov ebx, [esp + 8]     ; Get pointer to first argument
    
    ; Process the argument string pointed to by EBX
    mov esi, ebx           ; Point to argument string
    
print_arg:
    mov al, [esi]          ; Get character
    test al, al            ; Check for null terminator
    jz arg_done            ; Jump if end of string
    
    ; Print character (simplified - normally use system call)
    inc esi                ; Next character
    jmp print_arg
    
arg_done:
    jmp exit_program
    
no_args:
    ; Handle case with no arguments
    
exit_program:
    mov eax, 1
    mov ebx, 0
    int 0x80
```

## Advanced String Operations

### String Tokenization (Split by Delimiter)
```assembly
section .data
    text db 'word1,word2,word3', 0
    delimiter db ','

section .bss
    tokens resd 10         ; Array to store token pointers

section .text
    global _start

_start:
    mov esi, text          ; Source string
    mov edi, tokens        ; Token array
    mov edx, 0             ; Token count
    
    ; Store first token
    mov [edi], esi         ; Store pointer to first token
    add edi, 4             ; Next token slot
    inc edx                ; Increment token count
    
tokenize_loop:
    mov al, [esi]          ; Get current character
    test al, al            ; Check for end of string
    jz tokenize_done       ; Jump if null terminator
    
    cmp al, [delimiter]    ; Check if delimiter
    jne next_char          ; Jump if not delimiter
    
    ; Found delimiter
    mov byte [esi], 0      ; Replace delimiter with null
    inc esi                ; Move past delimiter
    mov [edi], esi         ; Store pointer to next token
    add edi, 4             ; Next token slot
    inc edx                ; Increment token count
    jmp tokenize_loop
    
next_char:
    inc esi                ; Next character
    jmp tokenize_loop
    
tokenize_done:
    ; EDX contains number of tokens
    ; tokens array contains pointers to each token
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80
```

## Practice Exercises

1. **Palindrome Checker**: Check if a string reads the same forwards and backwards
2. **Word Counter**: Count words in a sentence (separated by spaces)
3. **String Replace**: Replace all occurrences of one character with another
4. **Base64 Encoder**: Implement simple base64 encoding for strings

## Performance Tips

- Use string instructions (MOVSB, SCASB) for bulk operations
- Process multiple bytes at once when possible (MOVSD for 4 bytes)
- Minimize memory access by keeping frequently used data in registers
- Use direction flag (CLD/STD) appropriately for string operations

---

**Next Module**: [Comparisons and Flags](07-comparisons.md)
