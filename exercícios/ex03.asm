; Escreva um programa que leia duas constantes numéricas inteiras e imprima o maior dentre os dois 
; números informados. Se os valores forem iguais, o programa pode imprimir qualquer uma das 
; variáveis.

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
    numero_um dd 540
    numero_dois dd 600
    
.code
start:
    mov eax, numero_um         ; move o valor 100 para o registrador eax
    cmp numero_dois, eax       ; compara se numero dois é menor que eax

    jl primeiro_maior          ; se numero dois é menor, pula para primeiro_maior
    
    printf("o maior numero ou igual eh %d\n", numero_dois) ; se não, printa que o numero dois é maior
    jmp final_programa                                     ; finaliza o programa

primeiro_maior:
    printf("O maior numero ou igual eh %d\n", eax)         

final_programa:
    invoke ExitProcess, 0

end start