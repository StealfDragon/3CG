DiscardClass = {}
DiscardClass.__index = DiscardClass

function DiscardClass:new(xPos, yPos)
    local discardPile = setmetatable({}, self) 

    spotWidth = 1050
    spotHeight = 750

    discardPile.position = Vector(xPos, yPos)
    discardPile.size = Vector(spotWidth, spotHeight)
    discardPile.numCards = 0
    discardPile.cards = {}
    discardPile.lowestCard = nil
    discardPile.highestCard = nil

    return discardPile
end

function DiscardClass:addCard()

end