# Projeto final

### Incrementador de array paralelo

Programa que inicializa um array de entrada de 1024 posições com números inteiros (int) sequenciais positivos, a partir de um número fornecido pelo usuário na entrada padrão. Por exemplo, se o usuário entrar com o número inicial 1, então as 1000 posições do array devem ser preenchidas com os números 1, 2, 3, ..., 1000. Em seguida, esse programa preenche um array de saída de mesmo tamanho, onde cada posição deve receber o valor incrementado de 1 da respectiva posição do array de entrada. Por exemplo, se a posição 4 do array de entrada estiver preenchida com o número inteiro 4, a posição 4 do array de saída deverá ser preenchida com o número inteiro 5. O programa também escreve na saída padrão o resultado do somatório dos elementos do array de saída.
O programa é paralelizado com 4 threads utilizando o OpenMP e não sofre do problema de “falso compartilhamento” (false sharing).