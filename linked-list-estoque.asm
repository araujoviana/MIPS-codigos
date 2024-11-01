.data
    # Mensagens de erro
    msg_erro: .asciiz "\nOpção Inválida!\n\n"  # Mensagem exibida ao usuário quando uma opção inválida é selecionada no menu
    msg_lista_vazia:         .asciiz "\nErro: O estoque esta vazio.\n"
    msg_valor_invalido:     .asciiz "\n\nErro: valor inválido"
    msg_item_nao_encontrado: .asciiz "\n\nProduto não encontrado no estoque.\n"  # Mensagem informando que o produto não foi encontrado no estoque
    msg_codigo_existente: .asciiz "\n\nProduto com codigo inserido já existe.\n"  # Mensagem informando que o produto já existe no estoque

    # Mensagens de entrada de dados geral
    msg_qnt: .asciiz "Informe a quantidade de nós da lista:"  # Mensagem solicitando o número de nós da lista encadeada
    msg_valor: .asciiz "Digite o valor do produto:"  # Mensagem solicitando o valor do produto a ser inserido

    # Mensagens de exibição de informações na lista
    node: .asciiz "\nNo:"  # Indicação de um nó na lista
    key: .asciiz "\nCodigo:"  # Exibição do código do produto em um nó
    qtde: .asciiz "\nQuantidade:"  # Exibição da quantidade do produto em um nó

    # Menu principal
    menu: .asciiz "\n\n**** SISTEMA DE CONTROLE DE ESTOQUE ****\n1. Inserir um novo item no estoque\n2. Excluir um item do estoque\n3. Buscar um item pelo código\n4. Atualizar quantidade em estoque\n5. Imprimir os produtos em estoque\n6. Sair\nOpção:"

    # Mensagens para inserção de itens no estoque
    msg_codigo: .asciiz "\nDigite o código do produto:"  # Solicitação do código do produto para inserir um novo item
    msg_quantidade: .asciiz "\nDigite a quantidade:"  # Solicitação da quantidade do produto para inserção no estoque

    # Mensagens para exclusão de itens do estoque
    msg_excluir: .asciiz "\nDigite o código do produto a ser excluído:"  # Solicitação do código do produto a ser removido do estoque
    msg_item_excluido: .asciiz "\nItem excluído.\n\n"  # Confirmação de que o item foi excluído com sucesso

    # Mensagens para busca de itens no estoque
    msg_buscar: .asciiz "\nDigite o código do produto a ser encontrado:"  # Solicitação do código do produto para busca
    msg_item_encontrado: .asciiz "\n\nProduto encontrado! Código: "  # Confirmação de que o produto foi encontrado no estoque

    # Mensagem para atualização de itens no estoque
    msg_item_atualizado: .asciiz "\n\nProduto atualizado com sucesso.\n"
    msg_atualizar: .asciiz "\nDigite o código do produto a ser atualizado:"  # Solicitação do código do produto para atualização
    msg_atualizacao_completa: .asciiz "Produto válido, Código: "
    
.text

main:
    # Exibir o menu
    li $v0, 4         
    la $a0, menu       
    syscall          

    # ler a opção do usuário
    li $v0, 5         
    syscall           
    move $t9, $v0
    
    # Verificar a opção
    blt $t9, 1, menu_invalido  # se $t9 < 1, é inválido
    bgt $t9, 6, menu_invalido  # se $t9 > 6, é inválido

    # chamar a função correspondente à opção
    beq $t9, 1, chama_inserir_novo_item
    beq $t9, 2, chama_excluir_item
    beq $t9, 3, chama_buscar_item
    beq $t9, 4, chama_atualizar_item
    beq $t9, 5, chama_imprimir_estoque
    beq $t9, 6, fim
    
    j main  # volta para o menu

# Chamada quando alguma opção inválida do menu é inserida pelo usuário
menu_invalido:
    # Exibir a mensagem de erro
    li $v0, 4         
    la $a0, msg_erro       
    syscall          
    
    j main  # Retorna ao menu

# Chamada quando algum valor inválido é inserido pelo usuário
valor_invalido:
    # Exibir a mensagem de erro
    li $v0, 4
    la $a0, msg_valor_invalido
    syscall

    j main  # Retorna ao menu


# CHAMADA DE FUNÇÕES ------------

chama_inserir_novo_item:
        jal inserir_novo_item
        j main

chama_excluir_item:
        jal excluir_item
        j main

chama_buscar_item:
        jal buscar_item
        j main

chama_atualizar_item:
        jal atualizar_item
        j main

chama_imprimir_estoque:
        jal imprimir_estoque
        j main

# ------- INSERCAO ITEM

inserir_novo_item:
    # Solicitar ao usuário o código do produto
    li $v0, 4
    la $a0, msg_codigo
    syscall

    # Ler o código inserido pelo usuário
    li $v0, 5
    syscall
    move $t1, $v0        # $t1 armazenará o código do produto

    blt $t1, 1, valor_invalido # Verificação do código (deve ser >= 1)

    # Verificar se o código já existe na lista
    move $t3, $s0       # Ponteiro temporário $t3 para percorrer a lista

verifica_codigo_existente:
    beq $t3, $zero, continuar_insercao   # Se $t3 é NULL, lista acabou e não encontrou o código

    lw $t4, 0($t3)       # Carrega o código do nó atual em $t4
    beq $t4, $t1, codigo_existente   # Se o código existe, pula para a mensagem

    # Avança para o próximo nó
    lw $t3, 8($t3)       # Atualiza $t3 para o próximo nó
    j verifica_codigo_existente     # Continua verificando

continuar_insercao:
    # Solicitar ao usuário a quantidade do produto
    li $v0, 4
    la $a0, msg_quantidade
    syscall

    # Ler a quantidade inserida pelo usuário
    li $v0, 5
    syscall
    move $t2, $v0        # $t2 armazenará a quantidade do produto

    blt $t2, 1, valor_invalido # Verificação da quantidade (deve ser >= 1)

    # Alocação de memória para o novo nó
    li $a0, 12          # Espaço necessário (12 bytes: 4 para NEXT, 4 para código, 4 para quantidade)
    li $v0, 9           # Syscall para alocação de memória na heap
    syscall
    move $s1, $v0       # $s1 armazena o endereço do novo nó

    # Armazenar código e quantidade no nó
    sw $t1, 0($s1)      # Armazena código na primeira posição (4 bytes)
    sw $t2, 4($s1)      # Armazena quantidade na segunda posição (4 bytes)
    li $t0, 0           # Inicializa próximo nó (NULL)
    sw $t0, 8($s1)      # Armazena NULL no campo NEXT

    # Inserir o novo nó na lista
    beq $s0, $zero, inserir_primeiro_no  # Se $s0 (HEAD) é NULL, insere como primeiro nó

    # Se a lista não está vazia, percorrer até o último nó e conectar o novo nó
    move $t3, $s0       # Ponteiro temporário $t3 para percorrer a lista

inserir_percorre_lista:
    lw $t4, 8($t3)      # Carrega o ponteiro NEXT do nó atual
    beq $t4, $zero, inserir_conecta_no  # Se NEXT é NULL, encontramos o último nó
    move $t3, $t4       # Avança para o próximo nó
    j inserir_percorre_lista

inserir_conecta_no:
    sw $s1, 8($t3)      # Conecta o último nó com o novo nó

    # Finalizar e retornar ao menu
    jr $ra

inserir_primeiro_no:
    move $s0, $s1       # Se a lista estava vazia, define HEAD como o novo nó
    jr $ra

# Mensagem de código existente
codigo_existente:
    li $v0, 4
    la $a0, msg_codigo_existente
    syscall
    jr $ra              # Retorna ao menu principal

# ------- REMOCAO ITEM

# Função para excluir um item do estoque com base no código do produto
excluir_item:
    # Solicitar ao usuário o código do produto a ser excluído
    li $v0, 4
    la $a0, msg_excluir
    syscall

    # Ler o código do produto a ser excluído
    li $v0, 5
    syscall
    move $t1, $v0  # $t1 contém o código do produto a ser excluído

    # Inicializa ponteiros para percorrer a lista
    move $t5, $s0   # $t5 aponta para o nó atual, começando do HEAD
    li $t6, 0       # $t6 é o ponteiro para o nó anterior, começa como NULL

# Loop para buscar o nó a ser excluído
excluir_loop:
    beq $t5, $zero, item_nao_encontrado  # Se $t5 (nó atual) for NULL, o item não existe

    lw $t7, 0($t5)           # Carrega o código do produto do nó atual em $t7
    beq $t7, $t1, excluir_no  # Se o código atual ($t7) é igual ao código alvo ($t1), exclui o nó

    # Avança para o próximo nó
    move $t6, $t5            # Atualiza o nó anterior para o nó atual
    lw $t5, 8($t5)           # Avança para o próximo nó usando o ponteiro NEXT
    j excluir_loop           # Continua o loop

# Excluir o nó atual
excluir_no:
    # Se o nó a ser excluído é o HEAD (primeiro nó)
    beq $t6, $zero, excluir_head

    # Nó está no meio ou no fim; ajusta ponteiro NEXT do nó anterior
    lw $t7, 8($t5)          # Carrega o endereço do próximo nó
    sw $t7, 8($t6)          # Atualiza o NEXT do nó anterior para "pular" o nó excluído
    j item_excluido          # Exibe mensagem e retorna ao menu

excluir_head:
    # Exclui o HEAD, atualizando-o para o próximo nó
    lw $s0, 8($t5)          # Atualiza o HEAD para o próximo nó
    j item_excluido          # Exibe mensagem e retorna ao menu

item_excluido:
    # Exibir mensagem de item excluído
    li $v0, 4
    la $a0, msg_item_excluido
    syscall
    jr $ra              # Volta ao menu principal

item_nao_encontrado:
    # Exibir mensagem de item não encontrado
    li $v0, 4
    la $a0, msg_item_nao_encontrado
    syscall
    jr $ra              # Volta ao menu principal

# ------- IMPRESSAO ESTOQUE

# Função para imprimir todos os itens no estoque
imprimir_estoque:
    # Verifica se a lista está vazia
    beq $s0, $zero, lista_vazia  # Se HEAD ($s0) é NULL, a lista está vazia

    # Inicializa ponteiro para percorrer a lista
    move $t5, $s0   # $t5 será usado para percorrer a lista, começando do HEAD

imprimir_loop:
    # Imprime o texto "Nó:"
    li $v0, 4
    la $a0, node
    syscall

    # Imprime o código do produto atual
    li $v0, 4
    la $a0, key
    syscall

    lw $a0, 0($t5)  # Carrega o código do produto do nó atual
    li $v0, 1
    syscall

    # Imprime a quantidade do produto atual
    li $v0, 4
    la $a0, qtde
    syscall

    lw $a0, 4($t5)  # Carrega a quantidade do produto do nó atual
    li $v0, 1
    syscall

    # Avança para o próximo nó
    lw $t5, 8($t5)  # Carrega o ponteiro NEXT do nó atual
    bne $t5, $zero, imprimir_loop  # Continua se NEXT não é NULL

    jr $ra  # Retorna ao menu principal

lista_vazia:
    # Exibir mensagem de lista vazia
    li $v0, 4
    la $a0, msg_lista_vazia
    syscall
    jr $ra

# ------- BUSCAR ITEM

# Função para buscar um item no estoque com base no código do produto
buscar_item:
    # Solicitar ao usuário o código do produto a ser buscado
    li $v0, 4
    la $a0, msg_buscar
    syscall

    # Ler o código do produto a ser buscado
    li $v0, 5
    syscall
    move $t1, $v0  # Armazena o código buscado em $t1

    blt $t1, 1, valor_invalido # verifica se o valor inserido é maior que zero

    # Inicializa ponteiro para percorrer a lista
    move $t5, $s0  # $t5 aponta para o HEAD da lista

# Loop de busca do item
buscar_loop:
    beq $t5, $zero, item_nao_encontrado  # Se $t5 é NULL, o item não existe na lista

    lw $t7, 0($t5)           # Carrega o código do produto do nó atual em $t7
    beq $t7, $t1, item_encontrado_busca  # Se o código atual ($t7) é igual ao código buscado ($t1), exibe o item

    # Avança para o próximo nó
    lw $t5, 8($t5)           # Atualiza $t5 para o próximo nó
    j buscar_loop            # Continua o loop

# Exibir informações do item encontrado
item_encontrado_busca:
    # Exibe mensagem "Produto encontrado!"
    li $v0, 4
    la $a0, msg_item_encontrado
    syscall

    # Exibir o código do produto
    li $v0, 1
    move $a0, $t7           # Carrega o código do produto no $a0 para exibir
    syscall

    # Exibe mensagem "Quantidade:"
    li $v0, 4
    la $a0, qtde
    syscall

    # Exibir a quantidade em estoque
    lw $t8, 4($t5)           # Carrega a quantidade do produto em $t8
    li $v0, 1
    move $a0, $t8            # Carrega a quantidade no $a0 para exibir
    syscall

    jr $ra              # Retorna ao menu principal

# ------- ATUALIZACAO ITEM

# Função para atualizar a quantidade de um item no estoque
atualizar_item:
    # Solicitar ao usuário o código do produto a ser atualizado
    li $v0, 4
    la $a0, msg_atualizar
    syscall

    # Ler o código do produto a ser atualizado
    li $v0, 5
    syscall
    move $t1, $v0  # Armazena o código buscado em $t1

    blt $t1, 1, valor_invalido # verifica se o valor inserido é maior que zero

    # Inicializa ponteiro para percorrer a lista
    move $t5, $s0  # $t5 aponta para o HEAD da lista

# Loop de busca do item a ser atualizado
atualizar_loop:
    beq $t5, $zero, item_nao_encontrado  # Se $t5 é NULL, o item não existe na lista

    lw $t7, 0($t5)           # Carrega o código do produto do nó atual em $t7
    beq $t7, $t1, item_para_atualizar  # Se o código atual ($t7) é igual ao código buscado ($t1), passa para atualização

    # Avança para o próximo nó
    lw $t5, 8($t5)           # Atualiza $t5 para o próximo nó
    j atualizar_loop         # Continua o loop

# Atualizar a quantidade do item encontrado
item_para_atualizar:
    # Solicitar ao usuário a nova quantidade
    li $v0, 4
    la $a0, msg_quantidade
    syscall

    # Ler a nova quantidade
    li $v0, 5
    syscall
    move $t2, $v0  # Armazena a nova quantidade em $t2

    blt $t2, 1, valor_invalido # Verificação da quantidade (deve ser >= 1)

    # Atualizar a quantidade no nó
    sw $t2, 4($t5)  # Armazena o valor de $t2 no campo de quantidade do nó

    # Exibir mensagem de confirmação
    li $v0, 4
    la $a0, msg_atualizacao_completa
    syscall

    # Exibir o código atualizado
    li $v0, 1
    move $a0, $t7
    syscall

    # Exibir a quantidade atualizada
    li $v0, 4
    la $a0, qtde
    syscall

    li $v0, 1
    move $a0, $t2
    syscall
    
    # Exibe o aviso de item atualizado
    li $v0, 4
    la $a0, msg_item_atualizado
    syscall


    jr $ra  # Retorna ao menu principal

# ------- FIM

# Função para liberar a memória da lista encadeada
liberar_lista:
    move $t5, $s0  # Inicia o ponteiro no HEAD da lista

liberar_loop:
    beq $t5, $zero, fim_liberacao # Se $t5 é NULL, não há mais nós para liberar

    lw $t6, 8($t5)           # Carrega o ponteiro para o próximo nó em $t6
    li $v0, 10               # syscall para liberar memória
    move $a0, $t5            # Passa o endereço do nó atual para liberar
    syscall

    move $t5, $t6            # Avança para o próximo nó
    j liberar_loop           # Continua o loop

fim_liberacao:
    jr $ra                   # Retorna da função de liberação

fim:
    # Libera a memoria da lista antes de encerrar
    jal liberar_lista

    # Encerrar o programa
    li $v0, 10        
    syscall
