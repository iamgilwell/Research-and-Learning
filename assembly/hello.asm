section .data
    msg db 'Hello World!',0xA
    msg_len equ $  - msg

section .text
    global _start

_start:
    ; Write to system call
    mov eax, 4          ; syscall: sys_write
    mov ebx, 1          ; file descriptor: stdout
    mov ecx, msg        ; pointer to message
    mov edx, msg_len    ; message length
    int 0x80            ; call kernel 
    ; Exit system call
    mov eax, 1          ; syscall: sys_exit
    xor ebx, ebx        ; exit code 0
    int 0x80            ; call kernel  
    
