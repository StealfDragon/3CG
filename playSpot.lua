PlaySpotClass = {}
PlaySpotClass.__index = PlaySpotClass

function PlaySpotClass:new(xPos, yPos)
    local playSpot = setmetatable({}, self, spotWidth, spotHeight) 

    playSpot.size = Vector(spotWidth, spotHeight)
    playSpot.position = Vector(math.floor(xPos + 0.5) + 0.5, math.floor(yPos + 0.5) + 0.5) - (playSpot.size * 0.5)
    playSpot.type = "playSpot"

    -- Below is organized code for storing player and enemy powers
    playSpot.totalPower = 0
    playSpot.playersPowers = {}
    local P1Power = 0
    local P2Power = 0
    table.insert(playSpot.playersPowers, P1Power)
    table.insert(playSpot.playersPowers, P2Power)

    -- Below is organized code for card and slot storage, which stores by index instead of unconnected and difficult to swap between (in loops) lists
    playSpot.numCards = 0
    playSpot.cards = {}
    local P1Cards = {}
    local P2Cards = {}
    table.insert(playSpot.cards, P1Cards)
    table.insert(playSpot.cards, P2Cards)

    playSpot.cardSlots = {}
    local P1CardSlots = {}
    local P2CardSlots = {}
    table.insert(playSpot.cardSlots, P1CardSlots)
    table.insert(playSpot.cardSlots, P2CardSlots)

    playSpot.lowestCard = nil
    playSpot.highestCard = nil

    playSpot:makeCardSlots()

    return playSpot
end

function PlaySpotClass:draw()
    -- Draws brown background
    love.graphics.setColor(0.259, 0.149, 0.055, 0.9)
    love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)

    -- Draws grey outline
    love.graphics.setColor(0.388, 0.388, 0.388, 1)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle("line", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)
    --love.graphics.setLineWidth(1)

    -- Draws all card slots
    love.graphics.setLineWidth(3)
    for i = 1, 2 do
        for _, pos in ipairs(self.cardSlots[i]) do
            love.graphics.rectangle("line", pos.x, pos.y, cardWidth, cardHeight, 100, 6)
        end
    end
    love.graphics.setLineWidth(1)
end

function PlaySpotClass:addCard(card)
    -- adds a card to the playspot, adds it to specifically the table of the player who called the function, and adds the card to the first available position (which is determined by checking how many cards are in the table - keeping cards at the bottom of this table will be handled in remove)
    local playerNum = card.playerNum
    table.insert(self.cards[playerNum], card)
    card.position = self.cardSlots[playerNum][#self.cards[playerNum]]
    card.home = self
    if card.playerNum == 2 then
        card.locked = true
    end
    --self.totalPower = self.totalPower + card.power
    --self.playersPowers[playerNum] = self.playersPowers[playerNum] + card.power
end

-- this function removes a card from the playSpot, and handles the positioning of the other cards accordingly
function PlaySpotClass:removeCard(card)
    local playerNum = card.playerNum
    local cardList = self.cards[playerNum]
    local indexToRemove = nil

    for i, c in ipairs(cardList) do
        if c == card then
            indexToRemove = i
            break
        end
    end

    if indexToRemove then
        table.remove(cardList, indexToRemove)

        for i = indexToRemove, #cardList do
            cardList[i].position = self.cardSlots[playerNum][i]
        end
    end
    
    card.home = nil

    --self.totalPower = self.totalPower - card.power
    --self.playersPowers[playerNum] = self.playersPowers[playerNum] - card.power
end

function PlaySpotClass:setAllPowers(num)

end

function PlaySpotClass:setPlayerPowers(num)

end

function PlaySpotClass:setEnemyPowers(num)

end

function PlaySpotClass:getAllPowers(num)
    return self.totalPower
end

function PlaySpotClass:getPlayerPowers()
    return self.playersPowers[1]
end

function PlaySpotClass:getEnemyPowers()
    return self.playersPowers[2]
end

function PlaySpotClass:makeCardSlots()
    -- Function that draws every card slot inside the larger playSpot. The gaps between the cards on each row are 7 pixels, and the gaps between the colums are 10 pixels. Can be changed, wouldn't recommend, might go back and make the whole thing more modular weeks from now.
    local xGap = 7
    local yGap = 10

    for i = 1, 2 do
        for j = 1, 4 do
            local x = self.position.x + (xGap * j) + (cardWidth * (j - 1))
            local y = self.position.y + (yGap * i) + (cardHeight * (i - 1))
            local pos = Vector(x, y)

            if i == 1 then
                table.insert(self.cardSlots[2], pos) 
            else
                table.insert(self.cardSlots[1], pos)
            end
        end
    end
end

-- helper function to fix "layer" issue experienced by playSurface in drawing, updating, and checking for mouse over all cards.
function PlaySpotClass:getAllCards()
    local all = {}
    for i = 1, 2 do
        for _, card in ipairs(self.cards[i]) do
            table.insert(all, card)
        end
    end
    return all
end

function PlaySpotClass:getCenterPos()
    local center = self.position + (self.size * 0.5)
    return center
end

function PlaySpotClass:getCenterX()
    local center = self.position + (self.size * 0.5)
    return center.x
end

function PlaySpotClass:getCenterY()
    local center = self.position + (self.size * 0.5)
    return center.y
end