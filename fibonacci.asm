.data
    # Textos para receber entrada e imprimir a saída
    entrada: .asciiz "\nInsira a quantidade de termos da sequência de Fibonacci: "
    resultado: .asciiz "Resultado: "
    erro_negativo_msg: .asciiz "Erro: número deve ser maior que zero\n"
    # Para separar os números no resultado final
    separador: .asciiz ", "
    
.text

main:
    # Solicita ao usuário a quantidade de termos
    li $v0, 4
    la $a0, entrada
    syscall
    
    # Recebe a quantidade de termos do usuário
    li $v0, 5
    syscall
    
    # Armazena a entrada
    move $t0, $v0
    
    # Verifica se o número é menor ou igual a zero
    blez $t0, erro_negativo
    
    # Chama a função Fibonacci para gerar a sequência
    jal fibonacci
    
    j main
    
erro_negativo:
    # Imprime o texto em "erro_negativo_msg"
    li $v0, 4
    la $a0, erro_negativo_msg
    syscall
    
    # Retorna ao início para nova entrada
    j main
    
fibonacci:
    # Inicializa os primeiros termos da sequência
    li $t1, 0          
    li $t2, 1        
    # Contador de termos  
    move $t3, $t0    
    
fibonacci_loop:
    # Se o contador for <= 0, finaliza o loop
    blez $t3, fim_fibonacci  
    
    # Imprime o termo atual
    li $v0, 1
    move $a0, $t1
    syscall
    
    # Verifica se é o último termo, se sim, não imprime a virgula
    ble $t3, 1, apos_virgula  
    
    # Imprime a vírgula
    li $v0, 4
    la $a0, separador
    syscall
   
apos_virgula: 
    # Calcula o próximo termo
    add $t4, $t1, $t2 
    
    # Atualiza os termos para a próxima iteração
    move $t1, $t2     
    move $t2, $t4      
    
    # Decrementa o contador
    addi $t3, $t3, -1  
    
    # Repete o loop
    j fibonacci_loop

fim_fibonacci:
    # Finaliza o cálculo voltando pra main
    jr $ra             

