PlaySpotClass = {}
PlaySpotClass.__index = PlaySpotClass

function PlaySpotClass:new(xPos, yPos)
    local playSpot = setmetatable({}, self, spotWidth, spotHeight) 

    playSpot.size = Vector(spotWidth, spotHeight)
    playSpot.position = Vector(xPos, yPos) - (playSpot.size * 0.5)
    playSpot.numCards = 0
    playSpot.cards = {}
    playSpot.totalPower = 0

    playSpot.numPlayerCards = 0
    playSpot.playerCards = {}
    playSpot.playerCardSpots = {}

    playSpot.numEnemyCards = 0
    playSpot.enemyCards = {}
    playSpot.enemyCardSpots = {}

    playSpot.lowestCard = nil
    playSpot.highestCard = nil

    playSpot:makeCardSlots()

    return playSpot
end

function PlaySpotClass:draw()
    --love.graphics.setColor(0.53, 0.55, 0.55, 0.2)
    love.graphics.setColor(0.259, 0.149, 0.055, 0.9)
    love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)

    love.graphics.setColor(0.388, 0.388, 0.388, 1)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle("line", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)
    --love.graphics.setLineWidth(1)

    love.graphics.setLineWidth(3)
    for _, pos in ipairs(self.enemyCardSpots) do
        love.graphics.rectangle("line", pos.x, pos.y, cardWidth, cardHeight, 100, 6)
    end

    for _, pos in ipairs(self.playerCardSpots) do
        love.graphics.rectangle("line", pos.x, pos.y, cardWidth, cardHeight, 100, 6)
    end
    love.graphics.setLineWidth(1)
end

function PlaySpotClass:addCard()

end

function PlaySpotClass:removeCard()

end

function PlaySpotClass:setAllPowers()

end

function PlaySpotClass:setPlayerPowers()

end

function PlaySpotClass:setEnemyPowers()

end

function PlaySpotClass:makeCardSlots()
    local xGap = 7
    local yGap = 10

    for i = 1, 2 do
        for j = 1, 4 do
            local x = self.position.x + (xGap * j) + (cardWidth * (j - 1))
            local y = self.position.y + (yGap * i) + (cardHeight * (i - 1))
            local pos = Vector(x, y)

            if i == 1 then
                table.insert(self.enemyCardSpots, pos) 
            else
                table.insert(self.playerCardSpots, 1, pos)
            end
        end
    end
end

