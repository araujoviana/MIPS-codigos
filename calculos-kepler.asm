# Matheus Gabriel Viana Araujo - 10420444
# Enzo Carvalho Pagliarini - 10425707

.data
# Entrada do usuário
raio_input: .asciiz "Insira o raio: "

# Mensagens de erro
entrada_negativa: .asciiz "\nErro: Raio negativo.\n"
entrada_zerada: .asciiz "\nErro: Raio zero causa divisão por zero.\n"

# Saída
saida_primeiro: .asciiz "***** Informações sobre o Satélite *****\n     Velocidade: "
saida_segundo: .asciiz " km/seg\n     Raio: "
saida_terceiro: .asciiz " km\n     Período da órbita do satélite: "
saida_quarto: .asciiz " seg\n****************************************\n"

# Valores predefinidos
constante_gravitacao: .double 6.674e-11
massa_terra: .double 5.972e24
pi: .double 3.14159265
mil: .double 1000.0
zero: .double 0.0

.text

main:

	# Armazena os valores constantes em registradores
	l.d $f2, constante_gravitacao
	l.d $f4, massa_terra

	# Imprime o menu de entrada
	li $v0, 4
	la $a0, raio_input
	syscall
	

	# Recebe o double do raio 
	li $v0, 7
	syscall
	
    	# Verifica se o valor do raio é negativo
    	l.d $f6, zero
    	c.lt.d $f0, $f6      
    	bc1t entrada_invalida  
	
    	# Verifica se o valor do raio é zero
   	c.eq.d $f0, $f6
   	bc1t entrada_zero  
	
	# VELOCIDADE

	# Converte o raio para metros
	l.d $f10, mil
	mul.d $f0, $f0, $f10
	
	# G * M
	mul.d $f12, $f2, $f4
	# G*M/r
	div.d $f12, $f12, $f0
	# raiz quadrada de G*M/r
	sqrt.d $f12, $f12
	
	# Imprime a primeira parte da saída
	la $a0, saida_primeiro
	li $v0, 4
	syscall
	
	# Converte velocidade novamente para quilometros
	div.d $f12, $f12, $f10
	
	# Imprime o double
	li $v0, 3
	syscall

	# Imprime a segunda parte da saída
	la $a0, saida_segundo
	li $v0, 4
	syscall

	# RAIO
	
	# Converte raio novamente para quilometros
	div.d $f0, $f0, $f10
				
	# Imprime o raio a partir da entrada do usuário
	mov.d $f12, $f0 
	li $v0, 3
	syscall
	
	# Imprime a terceira parte da saída
	la $a0, saida_terceiro
	li $v0, 4
	syscall
	
	# PERÍODO
	
	# Converte o raio para metros
	l.d $f10, mil
	mul.d $f0, $f0, $f10
	
	# Carrega o valor do pi
	l.d $f12, pi
	
	# 4 * pi^2
	mul.d $f12, $f12, $f12 # Eleva f12 ao quadrado
	li $t0, 4 # Carrega o número quatro
	mtc1.d $t0, $f6 # Move pro Coproc 1 de double
	cvt.d.w $f6, $f6 # Converte de inteiro pra double
	mul.d $f12, $f12, $f6 
	
	# G * M
	mul.d $f6, $f2, $f4
	
	# 4*pi^2/G*M
	div.d $f12, $f12, $f6

	
	# r^3
	mul.d $f6, $f0, $f0
	mul.d $f6, $f6, $f0
	
	# Periodo = sqrt((4*pi^2/G*M) * r^3)
	mul.d $f12, $f12, $f6
	sqrt.d $f12, $f12

	# Imprime o periodo
	li $v0, 3
	syscall
	
	# Imprime quarta parte da saída
	la $a0, saida_quarto
	li $v0, 4
	syscall
	
	j fim

# Caso o raio seja negativo, imprime uma mensagem de erro	
entrada_invalida:
	li $v0, 4
	la $a0, entrada_negativa
	syscall

	j fim
	
# Caso o raio seja zero, imprime uma mensagem de erro
entrada_zero:
	li $v0, 4
	la $a0, entrada_zerada
	syscall
	j fim
	
fim:
	# Finaliza o código
	li $v0, 10
	syscall	