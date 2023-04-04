Tabuleiro = {}
Game_loop = true


function criarTabuleiro()
    
    for i = 1, 8 do
        Tabuleiro[i] = {}
        for j = 1, 8 do
            if (i + j) % 2 == 0 then
                if i < 4 then
                    Tabuleiro[i][j] = "w" --Coloca peças brancas (da máquina)
                elseif i > 5 then
                    Tabuleiro[i][j] = "b" --Coloca peças pretas (do jogador)
                else
                    Tabuleiro[i][j] = "." --Casas com "." indicam que a casa está vazia e é uma casa preta
                end
            else
                Tabuleiro[i][j] = "*" --Casas com "*" indicam que é uma casa branca, não é possível ter peças nela
            end
        end
    end
end --Fim do método criarTabuleiro


function printTabuleiro()
    io.write("  j= 1  2  3  4  5  6  7  8\n\n")
    io.write("i=\n")
    local num = 1
    for i = 1, 8 do
        io.write(num .. "    ")
        num = num + 1
        print(table.concat(Tabuleiro[i], "  "))
    end
end --Fim do método printTabuleiro


function verificarPecaPreta(posicaoPeca) --Metodo para verificar se a peça escolhida é a do jogador (preta)
    local linha = tonumber(posicaoPeca:sub(1,1))
    local coluna = tonumber(posicaoPeca:sub(2,2))
    
    if Tabuleiro[linha][coluna] == "b" or "B" then
        return true
    else
        return false
    end
end --Fim do metodo verificarPecaPreta

function verificarMovimento(posicaoInicial, posicaoFinal) --Metodo para verificar se o movimento é válido
    local linhaInicial = tonumber(posicaoInicial:sub(1, 1))
    local colunaInicial = tonumber(posicaoInicial:sub(2, 2))

    local linhaFinal = tonumber(posicaoFinal:sub(1, 1))
    local colunaFinal = tonumber(posicaoFinal:sub(2, 2))

    --A peça não pode andar para trás, a não ser que seja uma Dama ("B")
    if linhaFinal > linhaInicial and Tabuleiro[linhaInicial][colunaInicial] ~= "B" then
        return false
    elseif colunaInicial == colunaFinal then --O movimento não pode ser na mesma coluna
        return false
    elseif Tabuleiro[linhaFinal][colunaFinal] == "." then
        return true
    else return false
    end
end --Fim do metodo verificarMovimento


function moverPeca(posicaoInicial, posicaoFinal)
    local linhaInicial = tonumber(posicaoInicial:sub(1, 1))
    local colunaInicial = tonumber(posicaoInicial:sub(2, 2))

    local linhaFinal = tonumber(posicaoFinal:sub(1, 1))
    local colunaFinal = tonumber(posicaoFinal:sub(2, 2))

    local linhaDif = math.abs(linhaFinal - linhaInicial)
    local colunaDif = math.abs(colunaFinal - colunaInicial)

    --Se o movimento for de mais de duas casas 
    if linhaDif > 2 and Tabuleiro[linhaInicial][linhaFinal] ~= "B" then
        
    end
    io.write("Diferença L = " .. linhaDif .. "--" .. colunaDif)

end --Fim do metodo moverPeca

criarTabuleiro()
printTabuleiro()

--Loop principal do Jogo--
while Game_loop do 
    io.write("Qual peca deseja mover (numero da linha e coluna juntos)?\n")
    
    local posicaoInicial = io.read("l")

    while (not verificarPecaPreta(posicaoInicial)) do --Enquanto não selecionar peça preta o jogo não prossegue
        print("peca invalida, insira novamente:")
        posicaoInicial = io.read("l")
    end

    io.write("Para onde deseja mover (numero da linha e coluna juntos)?\n")
    local posicaoFinal = io.read("l")
    
    while (not verificarMovimento(posicaoInicial, posicaoFinal)) do --Enquanto não informar movimento válido, o jogo não prossegue
        print("movimento invalido, insira novamente para onde deseja mover:")
        posicaoFinal = io.read("l")
    end
    
    moverPeca(posicaoInicial, posicaoFinal) --Criar método moverPeca
    io.write "teste"
end 
