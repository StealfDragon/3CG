PlaySpotClass = {}
PlaySpotClass.__index = PlaySpotClass

function PlaySpotClass:new(xPos, yPos)
    local playSpot = setmetatable({}, self, spotWidth, spotHeight) 

    --spotWidth = 320
    --spotHeight = 160

    playSpot.size = Vector(spotWidth, spotHeight)
    playSpot.position = Vector(xPos, yPos) - (playSpot.size * 0.5)
    playSpot.numCards = 0
    playSpot.cards = {}

    playSpot.numPlayerCards = 0
    playSpot.playerCards = {}

    playSpot.numEnemyCards = 0
    playSpot.enemyCards = {}

    playSpot.lowestCard = nil
    playSpot.highestCard = nil

    return playSpot
end

function PlaySpotClass:draw()
    love.graphics.setColor(0.53, 0.55, 0.55, 0.4)
    love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)

    love.graphics.setColor(0.388, 0.388, 0.388, 1)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)
    love.graphics.setLineWidth(1)
end

function PlaySpotClass:addCard()

end

function PlaySpotClass:removeCard()

end

function HandClass:setAllPowers()

end

function HandClass:setPlayerPowers()

end

function HandClass:setEnemyPowers()

end