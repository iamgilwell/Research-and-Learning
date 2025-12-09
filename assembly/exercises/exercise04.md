# Exercise 4: String Manipulation

## Objective
Create a program that performs various string operations.

## Requirements
1. Calculate the length of a string without using strlen
2. Convert all lowercase letters to uppercase
3. Count occurrences of a specific character
4. Reverse the string in place

## Template
```assembly
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
    ; Your code here
    
    ; Task 2: Convert to uppercase
    ; Your code here
    
    ; Task 3: Count character occurrences
    ; Your code here
    
    ; Task 4: Reverse the string
    ; Your code here
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80
```

## Expected Results
For the string "hello world programming":
- Length: 22 characters
- After uppercase: "HELLO WORLD PROGRAMMING"
- Count of 'o': 2 occurrences
- After reverse: "GNIMMARGORP DLROW OLLEH"

## Hints
- Use a loop with null terminator check for length
- ASCII: 'a' to 'z' = 97-122, 'A' to 'Z' = 65-90
- Difference between upper and lower case = 32
- For reversal, use two pointers (start and end)

## Character Conversion Reference
```
'a' (97) - 32 = 'A' (65)
'b' (98) - 32 = 'B' (66)
...
'z' (122) - 32 = 'Z' (90)
```

## Bonus Challenges
1. Check if the string is a palindrome
2. Remove all spaces from the string
3. Count the number of words (space-separated)

## Testing Your Solution
```bash
# Build and debug
./tools/build.sh exercise04.asm debug
gdb ./exercise04

# Check string after modifications
(gdb) x/s &original
(gdb) x/wd &string_length
(gdb) x/wd &char_count
```

## Solution
Check `solutions/exercise04.asm` after attempting the exercise.
