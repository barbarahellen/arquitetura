; Escreva um programa que exiba na console os números entre 1000 e 1999 
; que divididos por 11 dão resto 5.

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
    mov ecx, 1000       ; move o valor 1000 para o registrador ecx pois é o reg para lacos
    mov ebx, 11         ; zera o registrador edx

laco:
    mov eax, ecx
    xor edx, edx
    div ebx             ; EDX:EAX / EBX
    cmp edx, 5
    je imprimir

continuacao:
    inc ecx 
    cmp ecx, 1999
    jle laco
    jmp final

imprimir:
    push ecx
    printf(" %d ", ecx)
    pop ecx
    jmp continuacao
    
final:    
    invoke ExitProcess, 0

end start