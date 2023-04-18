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


function verificarPeca(posicaoPeca) --Metodo para verificar se a peça escolhida é válida (não é vazia)
    local linha = tonumber(posicaoPeca:sub(1,1))
    local coluna = tonumber(posicaoPeca:sub(2,2))

    return Tabuleiro[linha][coluna] == "b" or Tabuleiro[linha][coluna] == "B" or Tabuleiro[linha][coluna] == "w" or Tabuleiro[linha][coluna] == "W"
end --Fim do metodo verificarPecaPreta


function verificarMovimento(posicaoInicial, posicaoFinal) --Metodo para verificar se o movimento é válido (Peça preta)
    local linhaInicial = tonumber(posicaoInicial:sub(1, 1))
    local colunaInicial = tonumber(posicaoInicial:sub(2, 2))

    local linhaFinal = tonumber(posicaoFinal:sub(1, 1))
    local colunaFinal = tonumber(posicaoFinal:sub(2, 2))

    -- verifica se a casa final está dentro do tabuleiro
    if linhaFinal < 1 or linhaFinal > 8 or colunaFinal < 1 or colunaFinal > 8 then
        return false
    end

    -- verifica se a peça é normal e preta
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
    --verifica se a peça é uma Dama preta
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

    -- verifica se a peça é normal e branca
    elseif Tabuleiro[linhaInicial][colunaInicial] == "w" then
        if (colunaFinal == colunaInicial + 1 or colunaFinal == colunaInicial + 2 or colunaFinal == colunaInicial - 1 or colunaFinal == colunaInicial - 2) then
            if ((linhaFinal == linhaInicial - 2 or linhaFinal == linhaInicial + 1 or linhaFinal == linhaInicial + 2) and (Tabuleiro[linhaFinal][colunaFinal] == ".")) then
                return true
            else
                return false
            end
        else
            return false
        end
    -- verificar se a peça é uma Dama branca
    elseif Tabuleiro[linhaInicial][colunaInicial] == "W" then
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
    local contPecas = 0

    -- verificar as diagonais para cima e para a direita
    local l = linha + 1
    local c = coluna + 1
    while l <= 8 and c <= 8 do
        if Tabuleiro[l][c] == "." then
            table.insert(casasPossiveis, tostring(l) .. tostring(c))
        elseif (Tabuleiro[linha][coluna] == "b" or Tabuleiro[linha][coluna] == "B") and (contPecas < 1) then -- Não pode pular pecas da mesma cor
            if Tabuleiro[l][c] == "b" or Tabuleiro[l][c] == "B" then
                break
            else --Contar quantas peças existem na diagonal, a Dama só pula uma peça inimiga
                contPecas = contPecas + 1 
            end
        elseif (Tabuleiro[linha][coluna] == "w" or Tabuleiro[linha][coluna] == "W") and (contPecas < 1) then -- Não pode pular pecas da mesma cor
            if Tabuleiro[l][c] == "w" or Tabuleiro[l][c] == "W" then
                break
            else 
                contPecas = contPecas + 1 
            end
        else
            break
        end
        l = l + 1
        c = c + 1
    end--Fim do while
    contPecas = 0

    -- verificar as diagonais para cima e para a esquerda
    l = linha + 1
    c = coluna - 1
    while l <= 8 and c >= 1 do
        if Tabuleiro[l][c] == "." then
            table.insert(casasPossiveis, tostring(l) .. tostring(c))
        elseif (Tabuleiro[linha][coluna] == "b" or Tabuleiro[linha][coluna] == "B") and (contPecas < 1) then 
            if Tabuleiro[l][c] == "b" or Tabuleiro[l][c] == "B" then
                break
            else 
                contPecas = contPecas + 1 
            end
        elseif (Tabuleiro[linha][coluna] == "w" or Tabuleiro[linha][coluna] == "W") and (contPecas < 1) then 
            if Tabuleiro[l][c] == "w" or Tabuleiro[l][c] == "W" then
                break
            else 
                contPecas = contPecas + 1 
            end
        else
            break
        end
        l = l + 1
        c = c - 1
    end--Fim do while
    contPecas = 0

    -- verificar as diagonais para baixo e para a direita
    l = linha - 1
    c = coluna + 1
    while l >= 1 and c <= 8 do
        if Tabuleiro[l][c] == "." then
            table.insert(casasPossiveis, tostring(l) .. tostring(c))
        elseif (Tabuleiro[linha][coluna] == "b" or Tabuleiro[linha][coluna] == "B") and (contPecas < 1) then 
            if Tabuleiro[l][c] == "b" or Tabuleiro[l][c] == "B" then
                break
            else 
                contPecas = contPecas + 1 
            end
        elseif (Tabuleiro[linha][coluna] == "w" or Tabuleiro[linha][coluna] == "W") and (contPecas < 1) then 
            if Tabuleiro[l][c] == "w" or Tabuleiro[l][c] == "W" then
                break
            else 
                contPecas = contPecas + 1 
            end
        else
            break
        end
        l = l - 1
        c = c + 1
    end--Fim do while
    contPecas = 0

    -- verificar as diagonais para baixo e para a esquerda
    l = linha - 1
    c = coluna - 1
    while l >= 1 and c >= 1 do
        if Tabuleiro[l][c] == "." then
            table.insert(casasPossiveis, tostring(l) .. tostring(c))
        elseif (Tabuleiro[linha][coluna] == "b" or Tabuleiro[linha][coluna] == "B") and (contPecas < 1) then 
            if Tabuleiro[l][c] == "b" or Tabuleiro[l][c] == "B" then
                break
            else
                contPecas = contPecas + 1 
            end
        elseif (Tabuleiro[linha][coluna] == "w" or Tabuleiro[linha][coluna] == "W") and (contPecas < 1) then 
            if Tabuleiro[l][c] == "w" or Tabuleiro[l][c] == "W" then
                break
            else 
                contPecas = contPecas + 1 
            end
        else
            break
        end
        l = l - 1
        c = c - 1
    end--Fim do while

    return casasPossiveis
end --Fim do método casasPossiveisDama


function moverPeca(posicaoInicial, posicaoFinal)
    local linhaInicial = tonumber(posicaoInicial:sub(1, 1))
    local colunaInicial = tonumber(posicaoInicial:sub(2, 2))

    local linhaFinal = tonumber(posicaoFinal:sub(1, 1))
    local colunaFinal = tonumber(posicaoFinal:sub(2, 2))

    local linhaDif = math.abs(linhaFinal - linhaInicial)
    local colunaDif = math.abs(colunaFinal - colunaInicial)

    --Peça não é uma Dama e é preta
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

                --Verifica se a peça pode continuar capturando
                local pecasCapturaveis = verificarCapturas(linhaFinal, colunaFinal)

                --Fica em loop enquanto existir peças a serem capturadas
                while pecasCapturaveis and #pecasCapturaveis > 0 do
                    linhaInicial, colunaInicial = linhaFinal, colunaFinal
                    printTabuleiro()
                    print("Existem pecas a serem capturadas. Escolha uma delas:")
                    for i, posicao in ipairs(pecasCapturaveis) do
                        print(i .. ": " .. posicao)
                    end
                    local escolha = io.read("l")
                    if tonumber(escolha) > 0 and tonumber(escolha) <= #pecasCapturaveis then
                        posicaoFinal = tostring(pecasCapturaveis[tonumber(escolha)])
                    else
                        print("Escolha inválida. Tente novamente.")
                    end

                    Tabuleiro[linhaInicial][colunaInicial] = "."

                    --Coloca a peça na nova posição
                    linhaFinal = tonumber(posicaoFinal:sub(1, 1))
                    colunaFinal = tonumber(posicaoFinal:sub(2, 2))
                    Tabuleiro[linhaFinal][colunaFinal] = "b"
                    --Retira a peça capturada
                    local linhaCaptura = (linhaInicial + linhaFinal)/2
                    local colunaCaptura = (colunaInicial + colunaFinal)/2
                    Tabuleiro[linhaCaptura][colunaCaptura] = "."

                    pecasCapturaveis = verificarCapturas(linhaFinal, colunaFinal)
                end --Fim do while

            else
                print("movimento invalido, insira novamente para onde deseja mover:")
                posicaoFinal = io.read("l")
                moverPeca(posicaoInicial, posicaoFinal)
            end
        end 
    
    --Peça é uma Dama Preta
    elseif (Tabuleiro[linhaInicial][colunaInicial] == "B") then
        if linhaDif == colunaDif then --Movimento de captura
            local linhaCaptura = linhaInicial
            local colunaCaptura = colunaInicial
    
            while linhaCaptura ~= linhaFinal do
                linhaCaptura = linhaCaptura + (linhaFinal - linhaInicial)/linhaDif
                colunaCaptura = colunaCaptura + (colunaFinal - colunaInicial)/colunaDif
    
                if Tabuleiro[linhaCaptura][colunaCaptura] == "w" or Tabuleiro[linhaCaptura][colunaCaptura] == "W" then
                    Tabuleiro[linhaCaptura][colunaCaptura] = "."
                elseif Tabuleiro[linhaCaptura][colunaCaptura] ~= "." then
                    print("movimento invalido, insira novamente para onde deseja mover:")
                    posicaoFinal = io.read("l")
                    moverPeca(posicaoInicial, posicaoFinal)
                    return
                end
            end
            
            --capturou a peça e moveu para a linha desejada
            Tabuleiro[linhaInicial][colunaInicial] = "."
            Tabuleiro[linhaFinal][colunaFinal] = "B"

            --Verifica se a peça pode continuar capturando
            local pecasCapturaveis = verificarCapturasDama(linhaFinal, colunaFinal)

            --Fica em loop enquanto existir peças a serem capturadas
            while pecasCapturaveis and #pecasCapturaveis > 0 do
                linhaInicial, colunaInicial = linhaFinal, colunaFinal
                printTabuleiro()

                print("Existem pecas a serem capturadas. Escolha uma delas:")
                for i, posicao in ipairs(pecasCapturaveis) do --"posicao" e uma table contendo: {linhaDisponivel, colunaDisponivel, linhaInimigo, colunaInimigo}
                    print(i .. ": " .. posicao[1] .. posicao[2])
                end
                local escolha = io.read("l")
                if tonumber(escolha) > 0 and tonumber(escolha) <= #pecasCapturaveis then
                    posicaoFinal = pecasCapturaveis[tonumber(escolha)]
                else
                    print("Escolha inválida. Tente novamente.")
                end

                Tabuleiro[linhaInicial][colunaInicial] = "."

                --Coloca a peça na nova posição
                linhaFinal = posicaoFinal[1]
                colunaFinal = posicaoFinal[2]
                Tabuleiro[linhaFinal][colunaFinal] = "B"

                --Retira a peça capturada
                local linhaCaptura = posicaoFinal[3]
                local colunaCaptura = posicaoFinal[4]
                Tabuleiro[linhaCaptura][colunaCaptura] = "."

                posicaoFinal = linhaFinal .. colunaFinal

                pecasCapturaveis = verificarCapturasDama(linhaFinal, colunaFinal)
            end --Fim do while
            
        else --Movimento simples
            Tabuleiro[linhaInicial][colunaInicial] = "."
            Tabuleiro[linhaFinal][colunaFinal] = "B"
        end
        
    --Peça não é dama e é branca
    elseif (Tabuleiro[linhaInicial][colunaInicial] == "w") then
        if linhaDif > 2 and colunaDif > 2 then
            print("movimento invalido, insira novamente para onde deseja mover:")
            posicaoFinal = io.read("l")
            moverPeca(posicaoInicial, posicaoFinal)
        elseif linhaDif == 1 and colunaDif == 1  then --Movimento simples de uma casa
            Tabuleiro[linhaInicial][colunaInicial] = "."
            Tabuleiro[linhaFinal][colunaFinal] = "w"
        elseif linhaDif == 2 and colunaDif == 2 then --Movimento de captura
            local linhaCaptura = (linhaInicial + linhaFinal)/2
            local colunaCaptura = (colunaInicial + colunaFinal)/2

            if Tabuleiro[linhaCaptura][colunaCaptura] == "b" or Tabuleiro[linhaCaptura][colunaCaptura] == "B" then
                Tabuleiro[linhaInicial][colunaInicial] = "."
                Tabuleiro[linhaCaptura][colunaCaptura] = "."
                Tabuleiro[linhaFinal][colunaFinal] = "w"
            else
                print("movimento invalido, insira novamente para onde deseja mover:")
                posicaoFinal = io.read("l")
                moverPeca(posicaoInicial, posicaoFinal)
            end
        end 
    
    --Peça é uma Dama Branca
    elseif (Tabuleiro[linhaInicial][colunaInicial] == "W") then
        
        Tabuleiro[linhaInicial][colunaInicial] = "."
        Tabuleiro[linhaFinal][colunaFinal] = "W"
        
    end

    verificarSeDama(posicaoFinal) --Verificar se a peça vira Dama após o término da jogada

end --Fim do metodo moverPeca

function verificarSeDama(posicao)
    local linha = tonumber(posicao:sub(1, 1))
    local coluna = tonumber(posicao:sub(2, 2))

    if Tabuleiro[linha][coluna] == "b" and linha == 1 then
        Tabuleiro[linha][coluna] = "B"
    end

    if Tabuleiro[linha][coluna] == "w" and linha == 8 then
        Tabuleiro[linha][coluna] = "W"
    end
end

function verificarCapturas(linha, coluna)
    local capturas = {}  -- lista de capturas possíveis a partir da posição dada
    
    -- verificar se é uma peça preta
    if Tabuleiro[linha][coluna] == "b" then
        
        -- verificar se pode capturar para cima à esquerda
        if linha >= 3 and coluna >= 3 then
            local peca_meio = Tabuleiro[linha-1][coluna-1]
            local peca_destino = Tabuleiro[linha-2][coluna-2]
            if (peca_meio == "w" or peca_meio == "W") and peca_destino == "." then
                table.insert(capturas, linha-2 .. coluna-2)
            end
        end
        
        -- verificar se pode capturar para cima à direita
        if linha >= 3 and coluna <= 6 then
            local peca_meio = Tabuleiro[linha-1][coluna+1]
            local peca_destino = Tabuleiro[linha-2][coluna+2]
            if (peca_meio == "w" or peca_meio == "W") and peca_destino == "." then
                table.insert(capturas, linha-2 .. coluna+2)
            end
        end
        
        -- verificar se pode capturar para baixo à esquerda
        if linha <= 6 and coluna >= 3 then
            local peca_meio = Tabuleiro[linha+1][coluna-1]
            local peca_destino = Tabuleiro[linha+2][coluna-2]
            if (peca_meio == "w" or peca_meio == "W") and peca_destino == "." then
                table.insert(capturas, linha+2 .. coluna-2)
            end
        end
        
        -- verificar se pode capturar para baixo à direita
        if linha <= 6 and coluna <= 6 then
            local peca_meio = Tabuleiro[linha+1][coluna+1]
            local peca_destino = Tabuleiro[linha+2][coluna+2]
            if (peca_meio == "w" or peca_meio == "W") and peca_destino == "." then
                table.insert(capturas, linha+2 .. coluna+2)
            end
        end
    end 
    
    return capturas
end --Fim do método verificarCapturas()

-- função que retorna uma lista de movimentos de captura disponíveis para uma dama
function verificarCapturasDama(linha, coluna)
    local capturas = {}
    local direcoes = {{-1,-1}, {-1,1}, {1,-1}, {1,1}} -- direções possíveis

    -- loop através das direções possíveis
    for _, direcao in ipairs(direcoes) do
        local i, j = linha + direcao[1], coluna + direcao[2]
        local encontrouInimigo = false
        local linhaInimigo, colunaInimigo

        while i >= 1 and i <= 8 and j >= 1 and j <= 8 do
            -- Se a posiçao atual é de uma peça preta, interrompe o loop e procura em outra direção
            if Tabuleiro[i][j] == "B" or Tabuleiro[i][j] == "b" then
                break
            end

            -- Se já encontrou peça branca e a posição atual está vazia, adiciona a lista de capturas
            if Tabuleiro[i][j] == "." and encontrouInimigo then
                table.insert(capturas, {i, j, linhaInimigo, colunaInimigo})
            end

            if Tabuleiro[i][j] == "W" or Tabuleiro[i][j] == "w" then
                encontrouInimigo = true
                linhaInimigo = i
                colunaInimigo = j
            end

            -- move para a próxima posição na direção atual
            i = i + direcao[1]
            j = j + direcao[2]
        end
    end

    return capturas
end

criarTabuleiro()


--Loop principal do Jogo--
while Game_loop do 
    printTabuleiro()
    io.write("Qual peca deseja mover (numero da linha e coluna juntos)?\n")
    
    local posicaoInicial = io.read("l")

    while (not verificarPeca(posicaoInicial)) do --Enquanto não selecionar peça preta ou branca jogo não prossegue
        print("peca invalida, insira novamente:")
        posicaoInicial = io.read("l")
    end

    --Criar método para verificar se a peça escolhida pode movimentar-se para algum lugar--

    io.write("Para onde deseja mover (numero da linha e coluna juntos)?\n")
    local posicaoFinal = io.read("l")
    
    while (not verificarMovimento(posicaoInicial, posicaoFinal)) do --Enquanto não informar movimento válido, o jogo não prossegue
        print("Movimento invalido, insira novamente para onde deseja mover:")
        posicaoFinal = io.read("l")
    end
    
    moverPeca(posicaoInicial, posicaoFinal)
end 
