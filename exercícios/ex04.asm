; Escreva um programa que leia uma constante numérica inteira e, em seguida, 
; escreva na tela se o número é par ou ímpar.

.686
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\msvcrt.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\msvcrt.lib
include \masm32\macros\macros.asm

    
.data
    numero dd 50
        
.code
start:
    mov eax, numero         ; move o valor para o registrador eax
    xor edx, edx            ; zera o registrador edx

    mov ebx, 2              ; move o valor 2 para ebx
    div ebx
    cmp edx, 0

    je eh_par

    printf("o numero eh impar")
    jmp final


eh_par:
    printf("o numero eh par")
    jmp final
    
    
final:    
    invoke ExitProcess, 0

end start