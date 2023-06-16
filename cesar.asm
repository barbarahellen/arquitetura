.686
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib


.data
    menu              db "Cifra de Cesar - Escolha uma opcao: ", 0AH, "1 - Criptografar", 0AH, "2 - Descriptografar", 0AH, "3 - Sair", 0AH, 0   ; mostra a mensagem e as opcoes no prompt
    msg_saida         db "Saindo...", 0AH, 0H                              ; mensagem para quando o programa for encerrado

    msg_arq_entrada   db "Digite o nome do arquivo de entrada:", 0AH, 0H   ; mensagem para digitar o arquivo de entrada
    msg_arq_saida     db "Digite o nome do arquivo de saida:", 0AH, 0H     ; mensagem para digitar o arquivo de saida
    msg_chave         db "Digite a chave (de 1 a 20):", 0AH, 0H            ; mensagem para digitar a chave      
    
    tam_msg           dd 0          ; armazena o tamanho das strings
    arq_entrada       db 50 dup(0)  ; armazena o nome do arquivo de entrada
    arq_saida         db 50 dup(0)  ; armazena o nome do arquivo de saida
    opcao_escolhida   db 5 dup(0)   ; armazena qual das 3 opcoes foi escolhida
    chave             db 5 dup(0)   ; armazena qual das chaves foi a escolhida
        
    input_handle      dd 0          ; armazena o handle do input
    output_handle     dd 0          ; armazena o handle do output
    qtd_caracteres    dd 0          ; armazena a quantidade de caracteres lidos no console

    arq_input_handle  dd 0          ; armazena o handle do CreateFile do arquivo de entrada
    arq_output_handle dd 0          ; armazena o handle do CreateFile do arquivo de saida

    buffer            db 512 dup(0) ; armazena os 512 bytes do arquivo
    write_count       dd 0          ; armazena quantos bytes foram escritos
    read_count        dd 0          ; armazena quantos bytes foram lidos 


.code

convert_enter:           ; funcao para converter o caractere ASCII CR em ASCII 0
 
    push ebp
    mov ebp, esp

    mov esi, [ebp+8]     ; acessa o primeiro argumento passado para a função

    proximo:       
        mov al, [esi]    ; Mover caractere atual para al
        inc esi          ; Apontar para o proximo caractere
        cmp al, 13       ; Verificar se eh o caractere ASCII CR - FINALIZAR
        jne proximo       
        dec esi          ; Apontar para o caractere anterior

    xor al, al           ; ASCII 0
    mov [esi], al        ; Inserir ASCII 0 no lugar o ASCII CR

    mov esp, ebp
    pop ebp
    ret


arquivos:                ; funcao para pedir ao usuario os nomes dos arquivos e a chave

    push ebp
    mov ebp, esp

    mov esi, [ebp+8]

    ; mensagem para pedir ao usuario o nome do arquivo de entrada
    invoke WriteConsole, output_handle, addr msg_arq_entrada, sizeof msg_arq_entrada-1, addr qtd_caracteres, NULL
    
    ; aguardando ele colocar o nome do arquivo de entrada
    invoke ReadConsole, input_handle, addr arq_entrada, sizeof arq_entrada, addr qtd_caracteres, NULL
   
    mov esi, offset arq_entrada
    push esi
    call convert_enter         

    ; mensagem para pedir ao usuario o nome do arquivo de saida
    invoke WriteConsole, output_handle, addr msg_arq_saida, sizeof msg_arq_saida-1, addr qtd_caracteres, NULL

    ; aguardando o usuario digitar o nome do arquivo de saida
    invoke ReadConsole, input_handle, addr arq_saida, sizeof arq_saida, addr qtd_caracteres, NULL

    mov esi, offset arq_saida 
    push esi
    call convert_enter 
    
    ; mensagem para pedir ao usuario para digitar a chave
    invoke WriteConsole, output_handle, addr msg_chave, sizeof msg_chave-1, addr qtd_caracteres, NULL

    ; aguardando o usuario colocar o valor da chave
    invoke ReadConsole, input_handle, addr chave, sizeof chave, addr qtd_caracteres, NULL

    mov esi, offset chave 
    push esi
    call convert_enter

    ; cria o arquivo de saida 
    invoke CreateFile, addr arq_saida, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL
    mov arq_output_handle, eax

    ; abre o arquivo 
    invoke CreateFile, addr arq_entrada, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
    mov arq_input_handle, eax

    mov esp, ebp
    pop ebp
    ret

    
opcao1:                  ; funcao que eh chamada quando o usuario escolhe a opcao 1

    ; chama a funcao para pedir o nome dos arquivos e a chave
    call arquivos       

loop_read_write:         ; loop para ler e escrever os 512 bytes no arquivo  

    invoke ReadFile, arq_input_handle, addr buffer, 1, addr read_count, NULL
    ; verifica se nao chegou ao fim do arquivo de entrada
    cmp read_count, 0
    ; se sim, pula para o fim da execucao do codigo
    je fim
            
    ; converte a string que armazenam a chave em tipo numerico e coloca o valor dela na pilha
    invoke atodw, addr chave

    ; coloca a chave na pilha
    push eax
    
    ; coloca read_count na pilha
    push read_count   
        
    ; coloca o endereco do array de 512 bytes na pilha
    push offset buffer
    
    ; chama a funcao que criptografa
    call criptografar 

    ; depois que a funcao altera o arquivo, grava no arquivo de saida
    invoke WriteFile, arq_output_handle, addr buffer, read_count, addr write_count, NULL

    ; repete o loop 
    jmp loop_read_write

jmp fim

criptografar:   
    push ebp
    mov ebp, esp 

    ; coloca endereco do array em esi
    mov esi, DWORD PTR [ebp+8]
 
    ; coloca a quantidade de bytes em edx
    mov edx, DWORD PTR [ebp+12]

    ; coloca a chave em ebx
    mov ebx, DWORD PTR [ebp+16]

    ; loop pra avancar esi e somar a chave até a quantidade de vezes igual ao segundo parametro
    loop_soma:
       mov al, [esi]
       add [esi], bl
       inc esi 
       cmp write_count, edx
       jl loop_soma

     mov esp, ebp
     pop ebp
     ret 12


opcao2:                     ; funcao que eh chamada quando o usuario escolhe a opcao 2

    call arquivos
    
loop_read_write2:           ; loop para ler e escrever os 512 bytes no arquivo  
    
    invoke ReadFile, arq_input_handle, addr buffer, 1, addr read_count, NULL
    ; verifica se chegou ao fim do arquivo de entrada
    cmp read_count, 0
    ; se sim, pula para o fim da execucao do codigo
    je fim
            
    ; converte a string que armazenam a chave em tipo numerico e coloca o valor dela na pilha
    invoke atodw, addr chave

    ; coloca a chave na pilha
    push eax
    
    ; coloca read_count na pilha
    push read_count   
        
    ; coloca o endereco do array de 512 bytes na pilha
    push offset buffer
    
    ; chama a funcao que criptografa
    call descriptografar 

    ; depois que a funcao altera o arquivo, grava no arquivo de saida
    invoke WriteFile, arq_output_handle, addr buffer, read_count, addr write_count, NULL

    ; repete o loop 
    jmp loop_read_write2
  
jmp fim

descriptografar:
    
    push ebp
    mov ebp, esp 
   
    ; coloca endereço do array em esi
    mov esi, DWORD PTR [ebp+8]
 
    ; coloca a quantidade de bytes em edx
    mov edx, DWORD PTR [ebp+12]

    ; coloca a chave em ebx
    mov ebx, DWORD PTR [ebp+16]

    ; loop pra avançar esi e subtrair a chave ate a quantidade de vezes igual ao segundo parametro
    loop_subtrai:

       mov al, [esi]
       sub [esi], bl
       inc esi 
       cmp write_count, edx
       jl loop_subtrai

     mov esp, ebp
     pop ebp
     ret 12
  
start:
    ; obtem o handle do console de entrada e saida padrao
    invoke GetStdHandle, STD_INPUT_HANDLE
    mov input_handle, eax
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov output_handle, eax
    
    ; mostra o menu com as opcoes 
    invoke WriteConsole, output_handle, addr menu, sizeof menu, addr qtd_caracteres, NULL

    ; aguardando o usuario colocar a opcao escolhida
    invoke ReadConsole, input_handle, addr opcao_escolhida, sizeof opcao_escolhida, addr qtd_caracteres, NULL

    mov esi, offset opcao_escolhida                 
    push esi
    call convert_enter
     
    ; dependendo da opcao escolhida, vai chamar uma funcao diferente
    invoke atodw, addr opcao_escolhida     
    cmp eax, 1     
    je opcao1
    cmp eax, 2
    je opcao2
    cmp eax, 3
    je fim 
   
fim:
    ; fecha os arquivos
    invoke CloseHandle, arq_output_handle
    invoke CloseHandle, arq_input_handle
    
    ; mostra mensagem indicando o fim do processamento
    invoke StrLen, addr msg_saida
    mov tam_msg, eax
    invoke WriteConsole, output_handle, addr msg_saida, tam_msg, addr qtd_caracteres, NULL
    
    ; fim da execucao
    invoke ExitProcess, 0
    
end start
