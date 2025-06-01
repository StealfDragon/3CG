HandClass = {}
HandClass.__index = HandClass

function HandClass:new(xPos, yPos)
    local hand = setmetatable({}, self) 

    hand.size = Vector(cardWidth * 8, cardHeight * 1.2)
    hand.position = Vector(xPos, yPos) - (hand.size * 0.5)

    hand.cards = {}
    hand.numCards = 0
    hand.lastPlayed = nil
    hand.lowestCard = nil
    hand.highestCard = nil
    hand.mana = 0
    hand.extraMana = 0

    return hand
end

function HandClass:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)
end

function HandClass:getNumCards()

end

function HandClass:setCosts()

end

function HandClass:setPowers()

end

function HandClass:reduceMana()

end