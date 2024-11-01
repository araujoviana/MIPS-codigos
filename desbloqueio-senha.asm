.data
	pergunta:.asciiz "Digite uma senha de 4 digitos: "
	#Texto para receber a senha
	correta:.asciiz "Senha correta!\n"
	#Texto para informar que a senha est� correta
	incorreta:.asciiz"Senha incorreta! Tente novamente\n"
	#Texto para informar que a senha est� incorreta\
	invalida:.asciiz"Entrada inv�lida, tente novamente\n"

.text

main:
	li $t0, 2468
	#Definindo a senha correta  no registrador $t0(2468)
	
	li $v0, 4
	la $a0, pergunta
	syscall 
	#imprimindo mensagem de pergunta para o usu�rio"
	
	li $v0, 5
	syscall
	move $t1,$v0	
	#ler a resposta do usu�rio e armazenar no registrador $t1\
	
	beq $t1, $zero, entrada_invalida
	#se usu�rio digitar 0, ir para a linha entrada_invalida
	
	xor $t2, $t0, $t1 	
	beq $t2, $zero, senha_correta
	#fazendo a compara��o bit a bit, se o resultado for zero a senha est� correta e desvia
	#para a linha senha_correta
	
	li $v0,4
	la $a0, incorreta
	syscall
	j main
	#caso a senha esteja incorreta exibe a mensagem de senha incorreta e vai para a linha fim
senha_correta:
	li $v0, 4
	la $a0, correta
	syscall
	j fim 
	#exibe a mensagem de senha correta para o usu�rio

entrada_invalida:
	li $v0, 4
	la $a0, invalida
	syscall
	j main
	#exibe a mensagem de entrada invalida e volta para a linha main
fim:
	li  $v0,10
	syscall
	#encerra o progama
