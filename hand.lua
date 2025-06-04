HandClass = {}
HandClass.__index = HandClass

function HandClass:new(xPos, yPos, playerNum)
    local hand = setmetatable({}, self) 

    hand.size = Vector(cardWidth * 8, cardHeight * 1.2)
    hand.position = Vector(xPos, yPos) - (hand.size * 0.5)
    hand.type = "hand"

    hand.cards = {}
    hand.lastPlayed = nil
    hand.lowestCard = nil
    hand.highestCard = nil
    hand.mana = 0
    hand.extraMana = 0
    hand.playerNum = playerNum

    return hand
end

function HandClass:draw()
    love.graphics.setColor(0.259, 0.149, 0.055, 0.9)
    love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)
    
    love.graphics.setColor(0.388, 0.388, 0.388, 1)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", self.position.x, self.position.y, self.size.x, self.size.y, 6, 6)
    love.graphics.setLineWidth(1)
end

function HandClass:addCard(card)
    table.insert(self.cards, card)
    card.position = self.position + Vector(25 + ((#self.cards - 1) * 80), cardHeight * 0.1)
    card.home = self
end

function HandClass:removeCard(card)
    local indexToRemove = nil

    for i, c in ipairs(self.cards) do
        if c == card then
            indexToRemove = i
            break
        end
    end

    if indexToRemove then
        table.remove(self.cards, indexToRemove)

        for i = indexToRemove, #self.cards do
            self.cards[i].position = self.position + Vector(25 + ((i - 1) * 80), cardHeight * 0.1)
        end
    end
    
    card.home = nil
end

function HandClass:setCosts()

end

function HandClass:setPowers()

end

function HandClass:reduceMana()

end

-- helper function to fix "layer" issue experienced by playSurface in drawing, updating, and checking for mouse over all cards.
function HandClass:getAllCards()
    return self.cards
end