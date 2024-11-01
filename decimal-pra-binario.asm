.data
	entrada:.asciiz "\nInsira um número decimal inteiro positivo: "
	erro:.asciiz"Insira um número decimal válido "
	resultado:.asciiz"Representação binária: "
	binario: .space 32
	linha:.asciiz "\n"
	

.text 

main :
	
	#solicitando a entrada para o usuário 
	li $v0, 4
	la $a0, entrada
	syscall 
	
	#lendo o número de entrada do usuário
	li $v0, 5
	syscall 
	
	#verificando se a entrada do usuário é negativo 
	bltz $v0, erro_negativo
	
	#move o valor de $v0 para o $a0
	move $a0, $v0
	
	jal decimal_para_binario
	
	li $v0, 4
	la $a0, resultado
	syscall
	
	jal imprime_binario
	
	li $v0, 10
	syscall
	
	
	

erro_negativo:
	#imprime na tela a mensagem de erro para o usuário
	li $v0, 4
	la $a0, erro
	syscall
	#volta para a main e pede mde novo um número para o usuário
	j main 
	
decimal_para_binario:
	#ajustando $sp para alocar 16 bytes, e salvando o valor de $a0
	addi $sp, $sp, -16  
    	sw $ra, 12($sp)     
    	sw $a0, 8($sp)     
    	sw $t0, 4($sp)      

	#colocando valor 2 em $t1 para ser utilizado como divisor e 0 em $t2 para salvar o resto das divisões
	li $t1, 2
	li $t2, 0
converte:
	#dividindo $a0 por 2, movendo resto para $t3 e o quociente para $a0
	divu $a0, $t1 
	mfhi $t3
	mflo $a0
	
	#armazenando o bit no array 
	sb $t3, binario($t2)
	addi $t2, $t2, 1
	
	#sai do loop se quociente 0
	bnez $a0, converte
	
	jr $ra 

imprime_binario:
	addi $sp, $sp, -16
	sw $ra, 12($sp)
	sw $t0, 8($sp)
	
	#inicia com o último índice usado
	addi $t2, $t2, -1
	
imprime_loop:
	#verifica se índice menor que zero
	bltz $t2, fim_imprime
	#carrega bit de memória
	lb $a0, binario($t2)
	#imprime bit 
	li $v0, 1
	syscall
	#decremente índice
	addi $t2, $t2, -1
	#repete o loop
	j imprime_loop
	
fim_imprime:
	#imprime nova linha
	li $v0,4
	la $a0, linha
	syscall
	
	lw $ra, 12($sp)
	lw $t0, 8($sp)
	addi $sp, $sp, 16
	jr $ra 
