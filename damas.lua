tabuleiro = {}
game_loop = true


function criarTabuleiro()
    
    for i = 1, 8 do
        tabuleiro[i] = {}
        for j = 1, 8 do
            if (i + j) % 2 == 0 then
                if i < 4 then
                    tabuleiro[i][j] = "w" --Coloca peças brancas (da máquina)
                elseif i > 5 then
                    tabuleiro[i][j] = "b" --Coloca peças pretas (do jogador)
                else
                    tabuleiro[i][j] = "." --Casas com "." indicam que a casa está vazia e é uma casa preta
                end
            else
                tabuleiro[i][j] = "*" --Casas com "*" indicam que é uma casa branca, não é possível ter peças nela
            end
        end
    end
end --Fim do método criarTabuleiro


function printTabuleiro()
    io.write("  j= 1  2  3  4  5  6  7  8\n\n")
    io.write("i=\n")
    num = 1
    for i = 1, 8 do
        io.write(num .. "    ")
        num = num + 1
        print(table.concat(tabuleiro[i], "  "))
    end
end --Fim do método printTabuleiro


function verificarPecaPreta(posicaoPeca) --Metodo para verificar se a peça escolhida é a do jogador (preta)
    local linha = tonumber(posicaoPeca:sub(1,1))
    local coluna = tonumber(posicaoPeca:sub(2,2))
    
    
    if tabuleiro[linha][coluna] == "b" then
        return true
    else
        return false
    end
end --Fim do metodo verificarPecaPreta

function verificarPosicaoVazia(posicao) --Metodo para verificar se a casa escolhida está vazia
    local linha = tonumber(posicao:sub(1,1))
    local coluna = tonumber(posicao:sub(2,2))
    
    if tabuleiro[linha][coluna] == "." then
        return true
    else
        return false
    end
end --Fim do metodo verificarPosicaoVazia

criarTabuleiro()
printTabuleiro()
while game_loop do
    io.write("Qual peca deseja mover (numero da linha e coluna juntos)?\n")
    
    posicaoPeca = io.read("l")

    while (not verificarPecaPreta(posicaoPeca)) do --Enquanto não selecionar peça preta o jogo não prossegue
        print("peca invalida, insira novamente:")
        posicaoPeca = io.read("l")
    end

    io.write("Para onde deseja mover (numero da linha e coluna juntos)?\n")
    posicaoFinal = io.read("l")
    
    while (not verificarPosicaoVazia(posicaoFinal)) do --Enquanto não selecionar posicao vazia ("."), o jogo não prossegue
        print("posicao invalida, insira novamente:")
        posicaoFinal = io.read("l")
    end
    
    moverPeca(posicaoPeca, posicaoFinal) --Criar método
    io.write "teste"
end 
