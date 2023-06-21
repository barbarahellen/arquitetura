; Escreva um programa que implemente a seguinte sentença da linguagem Java: 
; a = b + c + 100;
; As variáveis a, b e c são valores inteiros armazenados na memória. O conteúdo das variáveis b e c 
; deverão ser inicializados com valores definidos por você.

.686
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\msvcrt.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\msvcrt.lib
include \masm32\macros\macros.asm

.data?
    var_a dd ?
    
.data
    var_b dd 50
    var_c dd 20
    
.code
start:
    mov eax, var_b         ; move o valor 100 para o registrador eax
    add eax, var_c
    add eax, 100
    mov var_a, eax

    printf("variavel A eh igual a %d\n", var_a)
    invoke ExitProcess, 0
end start