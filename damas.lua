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

    return Tabuleiro[linha][coluna] == "b" or Tabuleiro[linha][coluna] == "B"
end --Fim do metodo verificarPecaPreta


function verificarMovimento(posicaoInicial, posicaoFinal) --Metodo para verificar se o movimento é válido
    local linhaInicial = tonumber(posicaoInicial:sub(1, 1))
    local colunaInicial = tonumber(posicaoInicial:sub(2, 2))

    local linhaFinal = tonumber(posicaoFinal:sub(1, 1))
    local colunaFinal = tonumber(posicaoFinal:sub(2, 2))

    -- verificar se a casa final está dentro do tabuleiro
    if linhaFinal < 1 or linhaFinal > 8 or colunaFinal < 1 or colunaFinal > 8 then
        return false
    end

    -- verificar se a peça é normal
    if Tabuleiro[linhaInicial][colunaInicial] == "b" then
        
        --A peça só pode andar para frente, e uma casa por vez (no momento de captura pode andar 2)
        if (colunaFinal == colunaInicial + 1 or colunaFinal == colunaInicial + 2 or colunaFinal == colunaInicial - 1 or colunaFinal == colunaInicial - 2) then
            if ((linhaFinal == linhaInicial + 2 or linhaFinal == linhaInicial - 1 or linhaFinal == linhaInicial - 2) and (Tabuleiro[linhaFinal][colunaFinal] == ".")) then
                return true
            else
                return false
            end
        else
            return false
        end
    -- verificar se a peça é uma Dama
    elseif Tabuleiro[linhaInicial][colunaInicial] == "B" then
        local casasPossiveis = casasPossiveisDama(linhaInicial, colunaInicial)
        --Verifica se a posicaoFinal está na diagonal da peça escolhida
        for _, casa in ipairs(casasPossiveis) do
            local linhaDestino = tonumber(casa:sub(1, 1))
            local colunaDestino = tonumber(casa:sub(2, 2))
            -- Se a casa final for possível para a Dama, o movimento é válido
            if linhaFinal == linhaDestino and colunaFinal == colunaDestino then
                if Tabuleiro[linhaFinal][colunaFinal] == "." then
                    return true
                else
                    return false
                end
            end
        end
        return false
    else
        return false
    end

end --Fim do metodo verificarMovimento

function casasPossiveisDama(linha, coluna)
    local casasPossiveis = {}

    -- verificar as diagonais para cima e para a direita
    local l = linha + 1
    local c = coluna + 1
    while l <= 8 and c <= 8 do
        if Tabuleiro[l][c] == "." then
            table.insert(casasPossiveis, tostring(l) .. tostring(c))
        else
            break
        end
        l = l + 1
        c = c + 1
    end
    -- verificar as diagonais para cima e para a esquerda
    l = linha + 1
    c = coluna - 1
    while l <= 8 and c >= 1 do
        if Tabuleiro[l][c] == "." then
            table.insert(casasPossiveis, tostring(l) .. tostring(c))
        else
            break
        end
        l = l + 1
        c = c - 1
    end
    -- verificar as diagonais para baixo e para a direita
    l = linha - 1
    c = coluna + 1
    while l >= 1 and c <= 8 do
        if Tabuleiro[l][c] == "." then
            table.insert(casasPossiveis, tostring(l) .. tostring(c))
        else
            break
        end
        l = l - 1
        c = c + 1
    end
    -- verificar as diagonais para baixo e para a esquerda
    l = linha - 1
    c = coluna - 1
    while l >= 1 and c >= 1 do
        if Tabuleiro[l][c] == "." then
            table.insert(casasPossiveis, tostring(l) .. tostring(c))
        else
            break
        end
        l = l - 1
        c = c - 1
    end
    return casasPossiveis
end --Fim do método casasPossiveisDama

function moverPeca(posicaoInicial, posicaoFinal)
    local linhaInicial = tonumber(posicaoInicial:sub(1, 1))
    local colunaInicial = tonumber(posicaoInicial:sub(2, 2))

    local linhaFinal = tonumber(posicaoFinal:sub(1, 1))
    local colunaFinal = tonumber(posicaoFinal:sub(2, 2))

    local linhaDif = math.abs(linhaFinal - linhaInicial)
    local colunaDif = math.abs(colunaFinal - colunaInicial)

    --Peça não é uma Dama
    if (Tabuleiro[linhaInicial][colunaInicial] == "b") then
        if linhaDif > 2 and colunaDif > 2 then
            print("movimento invalido, insira novamente para onde deseja mover:")
            posicaoFinal = io.read("l")
            moverPeca(posicaoInicial, posicaoFinal)
        elseif linhaDif == 1 and colunaDif == 1  then --Movimento simples de uma casa
            Tabuleiro[linhaInicial][colunaInicial] = "."
            Tabuleiro[linhaFinal][colunaFinal] = "b"
        elseif linhaDif == 2 and colunaDif == 2 then --Movimento de captura
            local linhaCaptura = (linhaInicial + linhaFinal)/2
            local colunaCaptura = (colunaInicial + colunaFinal)/2

            if Tabuleiro[linhaCaptura][colunaCaptura] == "w" or Tabuleiro[linhaCaptura][colunaCaptura] == "W" then
                Tabuleiro[linhaInicial][colunaInicial] = "."
                Tabuleiro[linhaCaptura][colunaCaptura] = "."
                Tabuleiro[linhaFinal][colunaFinal] = "b"
            else
                print("movimento invalido, insira novamente para onde deseja mover:")
                posicaoFinal = io.read("l")
                moverPeca(posicaoInicial, posicaoFinal)
            end
        end 
    
    --Peça é uma Dama
    else
        if linhaDif > 2 and colunaDif > 2 then
            print("movimento invalido, insira novamente para onde deseja mover:")
            posicaoFinal = io.read("l")
            moverPeca(posicaoInicial, posicaoFinal)
        elseif linhaDif == 1 and colunaDif == 1  then --Movimento simples de uma casa
            Tabuleiro[linhaInicial][colunaInicial] = "."
            Tabuleiro[linhaFinal][colunaFinal] = "b"
        elseif linhaDif == 2 and colunaDif == 2 then --Movimento de captura
            local linhaCaptura = (linhaInicial + linhaFinal)/2
            local colunaCaptura = (colunaInicial + colunaFinal)/2

            if Tabuleiro[linhaCaptura][colunaCaptura] == "w" or Tabuleiro[linhaCaptura][colunaCaptura] == "W" then
                Tabuleiro[linhaCaptura][colunaCaptura] = "."
                Tabuleiro[linhaFinal][colunaFinal] = "b"
            else
                print("movimento invalido, insira novamente para onde deseja mover:")
                posicaoFinal = io.read("l")
                moverPeca(posicaoInicial, posicaoFinal)
            end
        end
    end
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
    
    printTabuleiro()
end 
