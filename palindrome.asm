section .data 

msg db "Please enter a string:" ,10
len equ $ - msg

msg_y db "It is a palindrome",10
len_y equ $ - msg_y

msg_n db "It is not a palindrome",10
len_n equ $ - msg_n

section .bss
buffer resb 1024

section .text
_start:

main:

mov eax, 4          ;prompt for user string
mov ebx, 1
mov ecx, msg
mov edx, len
int 0x80

mov eax, 3          ; take user input and store in buffer
mov ebx, 0
mov ecx, buffer
mov edx, 1024
int 0x80

mov ebx, buffer     ;assuming that pressing enter is a mistake. exit program
mov al, [ebx]
cmp al, 10
je exit

is_palindrome:
    

if_yes:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_y
    mov edx, len_y
    int 0x80

if_no:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_n
    mov edx, len_n
    int 0x80







exit:
    mov eax, 1      ;exit...
    mov ebx, 0
    int 0x80