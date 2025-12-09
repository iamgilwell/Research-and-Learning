; Solution: Exercise 1 - Your First Assembly Program
; Prints a personalized greeting message

section .data
    msg db 'Hello, Alice!', 0xA, 0    ; Message with newline
    msg_len equ $ - msg - 1           ; Calculate length (exclude null terminator)
    
    ; Bonus: Age message
    age_msg db 'I am 25 years old.', 0xA, 0
    age_len equ $ - age_msg - 1

section .text
    global _start

_start:
    ; Print name message
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov ecx, msg        ; message pointer
    mov edx, msg_len    ; message length
    int 0x80            ; system call
    
    ; Print age message (bonus)
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout  
    mov ecx, age_msg    ; age message pointer
    mov edx, age_len    ; age message length
    int 0x80            ; system call
    
    ; Exit program
    mov eax, 1          ; sys_exit
    mov ebx, 0          ; exit status
    int 0x80            ; system call
