//  Alessandra Maria Ramos Barros de Moura (20200136795)
//  Bárbara Hellen Padilha da Silva (20200004867)

#include <stdio.h>
#include <stdalign.h>
#include <stdlib.h>
#include <omp.h>

#define ARRAY_SIZE 1024
#define NUM_THREADS 4

// alinha os arrays com 64 bytes
alignas(64) int array_input[ARRAY_SIZE];
alignas(64) int array_out[ARRAY_SIZE];

int main() {
    int input;
    int sum = 0;

    // solicita o valor inicial
    printf("Digite o numero inicial: ");
    scanf("%d", &input);

    // inicializa o array de entrada sequencialmente
    for (int i = 0; i < ARRAY_SIZE; i++) {
        array_input[i] = input + i;
    }

    // paraleliza o cálculo do array de saída
    #pragma omp parallel num_threads(NUM_THREADS)
    {
        int id = omp_get_thread_num();

        // determina o tamanho da thread que vai ser processada dividindo ARRAY_SIZE por NUM_THREADS
        int thread_size = ARRAY_SIZE / NUM_THREADS;

        // determina o índice a partir do qual a thread atual começará multiplicando o id pelo tamanho do pedaço da thread (thread_size).
        int start_thread = id * thread_size;

        /*
          Determina até onde a thread deve ir.
          se a thread atual for a última thread (id == NUM_THREADS - 1), ela irá até o final do array (ARRAY_SIZE).
          caso contrário, ela irá até start_thread + thread_size.
        */
        int end_thread = (id == NUM_THREADS - 1) ? ARRAY_SIZE : start_thread + thread_size;

        for (int i = start_thread; i < end_thread; i++) {
            // atualiza o valor do array de saida
            array_out[i] = array_input[i] + 1;
            // calcula o somatório dos elementos do array de saída
            #pragma omp atomic
                sum += array_out[i];
        }
    }

    // imprime o somatório
    printf("Somatorio dos elementos do array de saida: %d\n", sum);

    return 0;
}