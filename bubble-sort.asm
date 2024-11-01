.data
# Mensagens para entrada do usuario
mensagem_qtd: .asciiz "Digite a quantidade de numeros: "
mensagem_numero: .asciiz "Digite o numero: "
mensagem_ordenados: .asciiz "Numeros ordenados: "
mensagem_trocas: .asciiz "Total de trocas realizadas: "

# Strings para formatacao
nova_linha: .asciiz "\n"  # Para imprimir uma nova linha
separador: .asciiz ", " # Para separar cada item da lista ordenada

# Mensagem de erro
mensagem_erro: .asciiz "\n\nValor invalido.\n\n"

.text

main:
    # Solicitar a quantidade de números
    li $v0, 4                
    la $a0, mensagem_qtd     
    syscall

    # Ler a quantidade de números
    li $v0, 5                 
    syscall
    move $s0, $v0             # Armazenar quantidade em $s0
    
    # Rejeita valores invalidos (menores que 1)
    blt $s0, 1, valor_invalido_quantidade 

    # Alocar espaço para $s0 inteiros na heap
    li $v0, 9                 # syscall para alocar memória
    mul $a0, $s0, 4           # quantidade de bytes a alocar 
    syscall
    move $s1, $v0             # armazenar o endereço base da heap em $s1

    # Chamar a função para ler números
    jal ler_numeros

    # Inicializar contador de trocas
    li $s2, 0                 

    # Chamar a função para fazer o bubble sort na lista
    jal bubble_sort

    # Chamar a função para imprimir todos os números ordenados
    li $v0, 4                 
    la $a0, mensagem_ordenados # mensagem indicando que os números foram ordenados
    syscall

    jal imprimir_numeros      # Imprime a array ordenada

    # Nova linha para organizacao
    li $v0, 4           
    la $a0, nova_linha   
    syscall

    # Imprimir a quantidade de trocas feitas
    li $v0, 4               
    la $a0, mensagem_trocas   # mensagem indicando a quantidade de trocas
    syscall

    move $a0, $s2             # Mover o contador de trocas para $a0
    li $v0, 1                
    syscall

    li $v0, 4                
    la $a0, nova_linha        # Nova linha após a quantidade de trocas
    syscall

    j sair_programa           # pula para a saída

# Função que rejeita valores invalidos para a quantidade
valor_invalido_quantidade:
    li $v0, 4                
    la $a0, mensagem_erro    
    syscall
    
    j main
    
# Função que rejeita valores invalidos para o valor dos numeros individuais
valor_invalido_numero:
    li $v0, 4                
    la $a0, mensagem_erro 
    syscall
    
    j loop_leitura
    
# Função para ler os números
ler_numeros:
    li $t0, 0                 # contador de números lidos

loop_leitura:
    bge $t0, $s0, fim_leitura # se contador >= quantidade, sai do loop

    # Solicitar o número
    li $v0, 4                
    la $a0, mensagem_numero  
    syscall

    # Ler o número
    li $v0, 5                 
    syscall

    # Rejeita valores invalidos (menores que 1)
    blt $v0, 1, valor_invalido_numero
    
    # Calcular o endereço do número baseado em índice e armazenar na heap
    mul $t2, $t0, 4           # calcular offset (t0 * 4)
    add $t3, $s1, $t2         # endereço do elemento na heap
    sw $v0, 0($t3)            # armazena o número no endereço calculado

    addi $t0, $t0, 1          # incrementa o contador
    j loop_leitura            # volta para o início do loop

fim_leitura:
    jr $ra                    # retorna da função

# Função de Bubble Sort para ordenar os números na heap
bubble_sort:
    addi $t1, $s0, -1         # t1 = $s0 - 1 (último índice a ser comparado)

loop_externo:
    li $t0, 0                 # índice para a comparação inicial
    li $t4, 0                 # flag de troca para checar se houve troca

loop_interno:
    bge $t0, $t1, fim_loop_interno  # se t0 >= t1, termina o loop interno

    # Calcular endereço do elemento atual e próximo
    mul $t2, $t0, 4           # offset para o elemento atual
    add $t3, $s1, $t2         # endereço do elemento atual
    lw $t5, 0($t3)            # carrega o valor do elemento atual

    addi $t2, $t2, 4          # offset para o próximo elemento
    add $t6, $s1, $t2         # endereço do próximo elemento
    lw $t7, 0($t6)            # carrega o valor do próximo elemento

    # Comparar e trocar se necessário
    ble $t5, $t7, sem_troca   # se elemento atual <= próximo, não troca
    sw $t7, 0($t3)            # troca: coloca o próximo no lugar do atual
    sw $t5, 0($t6)            # coloca o atual no lugar do próximo
    li $t4, 1                 # seta flag para indicar que houve troca
    addi $s2, $s2, 1          # incrementa o contador de trocas em $s2

sem_troca:
    addi $t0, $t0, 1          # incrementa o índice
    j loop_interno            # repete o loop interno

fim_loop_interno:
    beq $t4, $zero, fim_ordenacao # se não houve troca, o array está ordenado
    addi $t1, $t1, -1         # decrementa o limite do loop externo
    j loop_externo            # repete o loop externo

fim_ordenacao:
    jr $ra                    # retorna da função
    
# Função para imprimir todos os números armazenados
imprimir_numeros:
    li $t0, 0                 # inicializa o índice para a iteração

loop_impressao:
    bge $t0, $s0, fim_impressao # se contador >= quantidade, sai do loop

    # Calcular o endereço do número baseado no índice
    mul $t2, $t0, 4           # calcular offset (t0 * 4)
    add $t3, $s1, $t2         # endereço do elemento na heap
    lw $a0, 0($t3)            # carregar o valor armazenado no endereço calculado

    # Imprimir o número
    li $v0, 1                 
    syscall

    # Verificar se é o último elemento antes de imprimir o separador
    addi $t0, $t0, 1          # incrementa o contador
    blt $t0, $s0, imprime_separador  # se ainda não é o último elemento, imprime separador
    j loop_impressao          # se é o último, volta ao loop

imprime_separador:
    # Imprimir o separador
    li $v0, 4                
    la $a0, separador
    syscall
    j loop_impressao          # volta para o início do loop

fim_impressao:
    jr $ra                    # retorna da função


sair_programa:
    # Finaliza o programa
    li $v0, 10                
    syscall
