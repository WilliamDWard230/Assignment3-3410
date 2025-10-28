;William Ward 10/27/25
;CSC-3410 Assignment 3
section .data 

msg db "Please enter a string:" ,10
len equ $ - msg

msg_y db "It is a palindrome",10
len_y equ $ - msg_y

msg_n db "It is not a palindrome",10
len_n equ $ - msg_n

section .bss
buffer resb 1024        ;reserve for max length of user input

section .text
GLOBAL _start

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

cmp byte [buffer], 10       ;check if user wants to exit
je exit

dec eax             ;remove newline... under assumption always going to be a new line

push eax
push buffer
call is_palindrome
add esp,8

cmp eax, 1          ;check the resulting eax value to determine if palindrome
je if_yes
jne if_no



if_yes:                     ;print "It is a palindome" and return to main loop to accept another string
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_y
    mov edx, len_y
    int 0x80
    jmp main

if_no:                      ;print "It is not a palindrome" and return to main loop to accept another string
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_n
    mov edx, len_n
    int 0x80
    jmp main


exit:
    mov eax, 1      ;exit...
    mov ebx, 0
    int 0x80


is_palindrome:              ;the stack
    push ebp
    mov ebp, esp
    push esi
    push edi

    mov esi, [ebp+8]        ;start of string
    mov ecx, [ebp+12]       ;length of string

    cmp ecx,1               ;if length is 1 then it is a palindrome
    jng .pal_true

    mov edi, esi            
    add edi, ecx
    dec edi

    mov edx, ecx
    shr edx, 1

.cmp_loop:
    cmp edx, 0          ;check if characters are exhausted
    je .pal_true

    mov al, [esi]       ;character at front
    mov bl, [edi]       ;char at end
    cmp al, bl          ;compare
    jne .pal_false      ; check flag for equality

    inc esi
    dec edi
    dec edx
    jmp .cmp_loop

.pal_true:              ;if true set eax to 1 and move to end sequence
    mov eax, 1
    jmp .end

.pal_false:             ;if false set eax to 0 and move to end sequence
    mov eax, 0  
    jmp .end  

.end:
    pop edi             ;clean up and return to main with eax true false value
    pop esi
    mov esp, ebp
    pop ebp
    ret