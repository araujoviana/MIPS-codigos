.data

# Texto do menu
menu: .asciiz "Menu: \n1. Soma\n2. Subtração\n3. Multiplicação\n4. Divisão\n5. Sair\nEscolha a operação (1/2/3/4/5): "
# Texto para receber valores
receber: .asciiz "Digite um número: "
# Texto para exibir o resultado
resultado: .asciiz "Resultado: "
# Texto para exibir o quociente
quociente_texto: .asciiz "Quociente: "
# Texto para exibir o resto
resto_texto: .asciiz "Resto: "
newline: .asciiz "\n"

.text
main:
    # Imprime o menu para o usuário
    li $v0, 4 
    la $a0, menu
    syscall

    # Recebe entrada do usuário
    li $v0, 5
    syscall
    move $t0, $v0

    # Verifica a entrada

    # Entrada é 1 -> pula pra função soma
    li $t1, 1
    beq $t0, $t1, soma

    # Entrada é 2 -> pula pra função subtração
    li $t1, 2
    beq $t0, $t1, subtracao
    
    # Entrada é 3 -> pula pra função multiplicacao
    li $t1, 3
    beq $t0, $t1, multiplicacao
    
    # Entrada é 4 -> pula pra função divisao
    li $t1, 4
    beq $t0, $t1, divisao
    
    # Entrada é 5 -> programa termina
    li $t1, 5
    beq $t0, $t1, fim

    # Se nenhuma entrada for reconhecida, recomeça o loop
    j main

soma:
    # Recebe o primeiro valor
    li $v0, 4
    la $a0, receber
    syscall

    li $v0, 5
    syscall
    move $t1, $v0

    # Recebe o segundo valor
    li $v0, 4
    la $a0, receber
    syscall

    li $v0, 5
    syscall
    move $t2, $v0

    # Adiciona os dois números
    add $t3, $t1, $t2

    # Imprime o texto "resultado"
    li $v0, 4
    la $a0, resultado
    syscall
    
    # Imprime o resultado
    move $a0, $t3
    li $v0, 1
    syscall

    # Imprime o newline
    li $v0, 4
    la $a0, newline
    syscall
    
    # Volta para o menu principal
    j main


subtracao:
    # Recebe o primeiro valor
    li $v0, 4
    la $a0, receber
    syscall

    li $v0, 5
    syscall
    move $t1, $v0

    # Recebe o segundo valor
    li $v0, 4
    la $a0, receber
    syscall

    li $v0, 5
    syscall
    move $t2, $v0

    # Subtrai os dois números
    sub $t3, $t1, $t2

    # Imprime o texto "resultado"
    li $v0, 4
    la $a0, resultado
    syscall
    
    # Imprime o resultado
    move $a0, $t3
    li $v0, 1
    syscall

    # Imprime o newline
    li $v0, 4
    la $a0, newline
    syscall
    
    # Volta para o menu principal
    j main
    
    
multiplicacao:
    # Recebe o primeiro valor
    li $v0, 4
    la $a0, receber
    syscall

    li $v0, 5
    syscall
    move $t1, $v0

    # Recebe o segundo valor
    li $v0, 4
    la $a0, receber
    syscall

    li $v0, 5
    syscall
    move $t2, $v0

    # Multiplica os dois números
    mult $t1, $t2

    # Move o resultado de LO para $t3
    mflo $t3

    # Imprime o texto "resultado"
    li $v0, 4
    la $a0, resultado
    syscall
    
    # Imprime o resultado
    move $a0, $t3
    li $v0, 1
    syscall

    # Imprime o newline
    li $v0, 4
    la $a0, newline
    syscall
    
    # Volta para o menu principal
    j main
    
divisao:
    # Recebe o primeiro valor
    li $v0, 4
    la $a0, receber
    syscall

    li $v0, 5
    syscall
    move $t1, $v0

    # Recebe o segundo valor
    li $v0, 4
    la $a0, receber
    syscall

    li $v0, 5
    syscall
    move $t2, $v0
    
    # Verifica se o segundo valor é 0
    beq $t2, $zero, divisao
    
    # Divide os dois números
    div $t1, $t2

    # Mova o quociente de LO para $t3 e o resto de HI para $t4
    mflo $t3   # Quociente
    mfhi $t4   # Resto

    # Imprime o texto "Quociente"
    li $v0, 4
    la $a0, quociente_texto
    syscall
    
    # Imprime o quociente
    move $a0, $t3
    li $v0, 1
    syscall
    
    # Imprime o newline
    li $v0, 4
    la $a0, newline
    syscall

    # Imprime o texto "Resto"
    li $v0, 4
    la $a0, resto_texto
    syscall

    # Imprime o resto
    move $a0, $t4
    li $v0, 1
    syscall

    # Imprime o newline
    li $v0, 4
    la $a0, newline
    syscall
    
    # Volta para o menu principal
    j main
    
# Encerra o código
fim:
    li $v0, 10
    syscall
