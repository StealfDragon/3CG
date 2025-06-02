PlaySpotClass = {}
PlaySpotClass.__index = PlaySpotClass

function PlaySpotClass:new(xPos, yPos)
    local playSpot = setmetatable({}, self, spotWidth, spotHeight) 

    playSpot.size = Vector(spotWidth, spotHeight)
    playSpot.position = Vector(xPos, yPos) - (playSpot.size * 0.5)
    playSpot.type = "playSpot"
    playSpot.numCards = 0
    playSpot.cards = {} -- not sure if I will end up using this, although now that I think about it, one of my "all card" loops defaults to checking objects' .cards table so I will have TODO something about that later.
    playSpot.totalPower = 0

    playSpot.P1NumCards = 0
    playSpot.P1Cards = {}
    playSpot.P1CardSpots = {}

    playSpot.P2NumCards = 0
    playSpot.P2Cards = {}
    playSpot.P2CardSpots = {}

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
    for _, pos in ipairs(self.P2CardSpots) do
        love.graphics.rectangle("line", pos.x, pos.y, cardWidth, cardHeight, 100, 6)
    end

    Draws player card spots
    for _, pos in ipairs(self.P1CardSpots) do
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
    -- Function that draws every card slot inside the larger playSpot. The gaps between the cards on each row are 7 pixels, and the gaps between the colums are 10 pixels. Can be changed, wouldn't recommend, might go back and make the whole thing more modular weeks from now.
    local xGap = 7
    local yGap = 10

    for i = 1, 2 do
        for j = 1, 4 do
            local x = self.position.x + (xGap * j) + (cardWidth * (j - 1))
            local y = self.position.y + (yGap * i) + (cardHeight * (i - 1))
            local pos = Vector(x, y)

            if i == 1 then
                table.insert(self.P2CardSpots, pos) 
            else
                table.insert(self.P1CardSpots, 1, pos)
            end
        end
    end
end

