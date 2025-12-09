; Hello World Program
; Demonstrates basic program structure and system calls

section .data
    msg db 'Hello, Assembly World!', 0xA, 0    ; Message with newline and null terminator
    msg_len equ $ - msg - 1                    ; Calculate length (exclude null terminator)

section .text
    global _start

_start:
    ; Write system call
    mov eax, 4          ; sys_write system call number
    mov ebx, 1          ; file descriptor 1 (stdout)
    mov ecx, msg        ; pointer to message
    mov edx, msg_len    ; number of bytes to write
    int 0x80            ; invoke system call

    ; Exit system call
    mov eax, 1          ; sys_exit system call number
    mov ebx, 0          ; exit status (0 = success)
    int 0x80            ; invoke system call
