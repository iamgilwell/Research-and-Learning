# Module 4: Data Types and Storage

## Assembly Data Types

Assembly doesn't have high-level data types like strings or objects. Everything is bytes, words, or double words.

### Basic Data Sizes

```assembly
db  ; Define Byte (8 bits)     - 0 to 255
dw  ; Define Word (16 bits)    - 0 to 65,535  
dd  ; Define Double (32 bits)  - 0 to 4,294,967,295
dq  ; Define Quad (64 bits)    - Large numbers
```

### Signed vs Unsigned

```assembly
section .data
    unsigned_byte db 255        ; Maximum unsigned byte
    signed_byte   db -128       ; Minimum signed byte (stored as 128)
    
    unsigned_word dw 65535      ; Maximum unsigned word
    signed_word   dw -32768     ; Minimum signed word
```

## String Storage

### Null-Terminated Strings (C-style)
```assembly
section .data
    name db 'John', 0           ; Null-terminated
    greeting db 'Hello', 0
```

### Length-Prefixed Strings
```assembly
section .data
    pascal_str db 5, 'H', 'e', 'l', 'l', 'o'  ; Length first
```

### Multi-line Strings
```assembly
section .data
    long_msg db 'This is a very long message ', \
               'that spans multiple lines', 0xA, 0
```

## Arrays and Tables

### Numeric Arrays
```assembly
section .data
    numbers dd 10, 20, 30, 40, 50    ; Array of 5 integers
    grades  db 85, 92, 78, 95, 88    ; Array of 5 bytes
    
    ; Pre-initialized array
    matrix dd 100 dup(0)             ; 100 zeros
```

### String Arrays
```assembly
section .data
    names db 'Alice', 0, 'Bob', 0, 'Charlie', 0
    
    ; Better approach - pointer table
    name_ptrs dd alice_str, bob_str, charlie_str
    alice_str db 'Alice', 0
    bob_str   db 'Bob', 0
    charlie_str db 'Charlie', 0
```

## Comprehensive Example

**File: datatypes.asm**
```assembly
section .data
    ; Different data sizes
    byte_val    db 42           ; 8-bit value
    word_val    dw 1000         ; 16-bit value
    dword_val   dd 100000       ; 32-bit value
    
    ; Strings
    message     db 'Data Types Demo', 0xA, 0
    msg_len     equ $ - message - 1
    
    ; Arrays
    scores      db 85, 90, 78, 92, 88
    score_count equ ($ - scores)
    
    ; Lookup table
    hex_digits  db '0123456789ABCDEF'

section .bss
    ; Uninitialized data (reserves space)
    buffer      resb 256        ; Reserve 256 bytes
    temp_word   resw 1          ; Reserve 1 word
    temp_dword  resd 1          ; Reserve 1 double word

section .text
    global _start

_start:
    ; Load different sized data
    mov al, [byte_val]      ; Load byte into AL
    mov ax, [word_val]      ; Load word into AX  
    mov eax, [dword_val]    ; Load dword into EAX
    
    ; Array access
    mov esi, scores         ; Point to array start
    mov al, [esi]          ; Get first element (85)
    mov al, [esi + 1]      ; Get second element (90)
    mov al, [esi + 4]      ; Get fifth element (88)
    
    ; String operations
    mov esi, message        ; Point to string
    mov al, [esi]          ; Get first character 'D'
    
    ; Hex digit lookup
    mov ebx, 10            ; Want hex digit for 10
    mov esi, hex_digits    ; Point to lookup table
    mov al, [esi + ebx]    ; Get 'A' (hex for 10)
    
    ; Store in uninitialized space
    mov [temp_dword], eax  ; Store value in reserved space
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80
```

## Memory Layout

### Program Memory Sections
```
High Memory
┌─────────────┐
│    Stack    │ ← ESP (grows downward)
├─────────────┤
│     ...     │
├─────────────┤
│    Heap     │ ← Dynamic allocation
├─────────────┤
│    .bss     │ ← Uninitialized data
├─────────────┤
│   .data     │ ← Initialized data
├─────────────┤
│   .text     │ ← Program code
└─────────────┘
Low Memory
```

### Endianness (Little Endian on x86)
```assembly
section .data
    number dd 0x12345678    ; Stored as: 78 56 34 12

section .text
    mov eax, [number]       ; EAX = 0x12345678
    mov al, [number]        ; AL = 0x78 (lowest byte)
    mov ah, [number + 1]    ; AH = 0x56 (next byte)
```

## Advanced Data Structures

### Structures (Manual Layout)
```assembly
section .data
    ; Person structure: name(16), age(4), salary(4)
    person1 db 'John Smith', 0, 0, 0  ; 16 bytes for name
            dd 25                      ; 4 bytes for age
            dd 50000                   ; 4 bytes for salary
    
    ; Offsets for structure access
    NAME_OFFSET   equ 0
    AGE_OFFSET    equ 16  
    SALARY_OFFSET equ 20

section .text
    global _start

_start:
    ; Access structure members
    mov esi, person1
    mov eax, [esi + AGE_OFFSET]     ; Get age (25)
    mov ebx, [esi + SALARY_OFFSET] ; Get salary (50000)
    
    ; Modify structure
    mov dword [esi + AGE_OFFSET], 26  ; Increment age
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80
```

## Data Conversion

### ASCII to Integer
```assembly
section .data
    ascii_num db '123', 0

section .text
    global _start

_start:
    ; Convert "123" to integer 123
    mov esi, ascii_num
    xor eax, eax           ; Result = 0
    xor ebx, ebx           ; Clear EBX
    
convert_loop:
    mov bl, [esi]          ; Get next digit
    test bl, bl            ; Check for null terminator
    jz done                ; Jump if end of string
    
    sub bl, '0'            ; Convert ASCII to digit
    imul eax, 10           ; Multiply result by 10
    add eax, ebx           ; Add new digit
    inc esi                ; Next character
    jmp convert_loop
    
done:
    ; EAX now contains 123
    mov eax, 1
    mov ebx, 0
    int 0x80
```

## Memory Alignment

### Aligned vs Unaligned Data
```assembly
section .data
    ; Aligned data (efficient)
    aligned_word   dw 1000      ; Starts at even address
    aligned_dword  dd 100000    ; Starts at 4-byte boundary
    
    ; Potentially unaligned
    byte_val       db 42        ; 1 byte
    unaligned_word dw 2000      ; May not be aligned
```

## Practice Exercises

1. **Student Records**: Create a structure for student data (name, ID, grades)
2. **Array Processing**: Sum all elements in an integer array
3. **String Length**: Calculate length of null-terminated string
4. **Data Conversion**: Convert integer to ASCII string

## Key Takeaways

- Assembly works with raw bytes - you define the interpretation
- Arrays are contiguous memory blocks accessed by offset
- Structures are manually laid out memory regions
- Endianness affects multi-byte data storage
- Memory alignment impacts performance

---

**Next Module**: [Memory Addressing](05-memory-addressing.md)
