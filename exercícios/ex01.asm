; Escreva um programa que calcule a soma dos 100 primeiros números inteiros positivos. O 
; resultado deverá ser armazenado no registrador eax e também deverá ser exibido na tela.

.686
.model flat, stdcall
option casemap :none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\msvcrt.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\msvcrt.lib
include \masm32\macros\macros.asm

.code
start:
    xor eax, eax         ; zera o registrador
    mov ecx, 1           ; inicia o laço em 1  

meu_laco:
    add eax, ecx         ; adiciona o valor de ecx a eax
    inc ecx
    cmp ecx, 100         ; compara se ecx é menor que 100
    jbe meu_laco         ; se menor ou igual a 100, continua no laco
    printf("O valor do somatorio eh %d\n", eax)   
    invoke ExitProcess, 0
end start