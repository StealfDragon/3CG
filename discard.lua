DiscardClass = {}
DiscardClass.__index = DiscardClass

function DiscardClass:new(xPos, yPos)
    local discardPile = setmetatable({}, self) 

    discardPile.size = Vector(cardWidth, cardHeight)
    discardPile.position = Vector(xPos, yPos) - (discardPile.size * 0.5)
    
    discardPile.numCards = 0
    discardPile.cards = {}
    discardPile.lowestCard = nil
    discardPile.highestCard = nil

    return discardPile
end

function DiscardClass:draw()
    love.graphics.setColor(0.58, 0, 0, 0.7)
    love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y, 100, 6)

    love.graphics.setColor(0.388, 0.388, 0.388, 1)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", self.position.x, self.position.y, self.size.x, self.size.y, 100, 6)
    love.graphics.setLineWidth(1)
end

function DiscardClass:addCard()

end