PlaySpotClass = {}
PlaySpotClass.__index = PlaySpotClass

function PlaySpotClass:new(xPos, yPos)
    local playSpot = setmetatable({}, self) 

    spotWidth = 1050
    spotHeight = 750

    playSpot.position = Vector(xPos, yPos)
    playSpot.size = Vector(spotWidth, spotHeight)
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