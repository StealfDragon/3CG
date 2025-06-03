PlaySpotClass = {}
PlaySpotClass.__index = PlaySpotClass

function PlaySpotClass:new(xPos, yPos)
    local playSpot = setmetatable({}, self, spotWidth, spotHeight) 

    playSpot.size = Vector(spotWidth, spotHeight)
    playSpot.position = Vector(xPos, yPos) - (playSpot.size * 0.5)
    playSpot.type = "playSpot"
    playSpot.totalPower = 0

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

    --[[ playSpot.P1NumCards = 0
    playSpot.P1Cards = {}

    playSpot.P2NumCards = 0
    playSpot.P2Cards = {}

    playSpot.P1CardSpots = {}
    playSpot.P2CardSpots = {} ]]

    playSpot.lowestCard = nil
    playSpot.highestCard = nil

    playSpot:makeCardSlots()

    return playSpot
end

function PlaySpotClass:draw()
    --love.graphics.setColor(0.53, 0.55, 0.55, 0.2)
    -- Draws brown background
    love.graphics.setColor(0.259, 0.149, 0.055, 0.9)
    love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)

    -- Draws grey outline
    love.graphics.setColor(0.388, 0.388, 0.388, 1)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle("line", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)
    --love.graphics.setLineWidth(1)

    -- Draws enemy card spots
    love.graphics.setLineWidth(3)
    for i = 1, 2 do
        for _, pos in ipairs(self.cardSlots[i]) do
            love.graphics.rectangle("line", pos.x, pos.y, cardWidth, cardHeight, 100, 6)
        end
    end
    love.graphics.setLineWidth(1)
    --[[ -- Draws player card spots
    for _, pos in ipairs(self.P1CardSpots) do
        love.graphics.rectangle("line", pos.x, pos.y, cardWidth, cardHeight, 100, 6)
    end ]]
    love.graphics.setLineWidth(1)
end

function PlaySpotClass:addCard(card)
    table.insert(self.cards, card)

    local playerNum = card.playerNum

    table.insert(self.cards[playerNum], card)
    card.position = self.cardSlots[playerNum][#self.cards[playerNum]]

    --[[ if card.playerNum == 1 then
        table.insert(self.P1Cards, card)
        self.P1NumCards = self.P1NumCards + 1
        card.position = self.P1CardSpots[self.P1NumCards]
    else
        table.insert(self.P2Cards, card)
        self.P2NumCards = self.P2NumCards + 1
        card.position = self.P2CardSpots[self.P2NumCards]
    end ]]
end

function PlaySpotClass:removeCard(card)

end

function PlaySpotClass:setAllPowers(num)

end

function PlaySpotClass:setPlayerPowers(num)

end

function PlaySpotClass:setEnemyPowers(num)

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

function PlaySpotClass:getAllCards()
    local all = {}
    for i = 1, 2 do
        for _, card in ipairs(self.cards[i]) do
            table.insert(all, card)
        end
    end
    return all
end