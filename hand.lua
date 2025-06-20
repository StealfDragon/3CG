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
    -- I decided not to use a player object because I can just make two hand objects and store the player info/methods in each hand
    hand.points = 0
    hand.mana = 1
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
    if self.playerNum == 1 then
        card.position = self.position + Vector(25 + ((#self.cards - 1) * 80), cardHeight * 0.1)
        card.faceDown = false
    else
        local startX = self.position.x + self.size.x - 25 - cardWidth
        card.position = Vector(startX - ((#self.cards - 1) * 80), self.position.y + cardHeight * 0.1)
    end
    card.home = self
    card.locked = false
    if card.wasInHand then self.mana = self.mana + card.cost end
    card.playerNum = self.playerNum
end

function HandClass:removeCard(card)
    if self.lastPlayed ~= nil then
        if self.lastPlayed.name ~= "Mnemosyne" then
            self.lastPlayed = card
        end
    else
        self.lastPlayed = card
    end
    local indexToRemove = nil

    for i, c in ipairs(self.cards) do
        if c == card then
            indexToRemove = i
            break
        end
    end

    if indexToRemove then
        table.remove(self.cards, indexToRemove)

        for i = 1, #self.cards do
            if self.playerNum == 1 then
                self.cards[i].position = self.position + Vector(25 + ((i - 1) * 80), cardHeight * 0.1)
            else
                local startX = self.position.x + self.size.x - 25 - cardWidth
                self.cards[i].position = Vector(startX - ((i - 1) * 80), self.position.y + cardHeight * 0.1)
            end
        end
    end
    
    card.home = nil
    card.wasInHand = true
    self.mana = self.mana - card.cost
end

function HandClass:changeCosts()

end

function HandClass:changePowers()

end

function HandClass:setMana(num)
    self.mana = num
end

function HandClass:getPoints()
    return self.points
end

function HandClass:getMana()
    return self.mana
end

-- helper function to fix "layer" issue experienced by playSurface in drawing, updating, and checking for mouse over all cards.
function HandClass:getAllCards()
    return self.cards
end

function HandClass:getCenterPos()
    local center = self.position + (self.size * 0.5)
    return center
end

function HandClass:getCenterX()
    local center = self.position + (self.size * 0.5)
    return center.x
end

function HandClass:getCenterY()
    local center = self.position + (self.size * 0.5)
    return center.y
end

function HandClass:getSize()
    return self.size
end

function HandClass:getSizeX()
    return self.size.x
end

function HandClass:getSizeY()
    return self.size.y
end