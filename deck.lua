DeckClass = {}
DeckClass.__index = DeckClass

function DeckClass:new(xPos, yPos, playerNum, hand)
    local deck = setmetatable({}, self) 

    deck.size = Vector(cardWidth, cardHeight)
    deck.position = Vector(xPos, yPos) - (deck.size * 0.5)

    deck.type = "deck"
    deck.hovered = false
    deck.pressed = false

    deck.cards = {}

    deck.playerNum = playerNum
    deck.hand = hand

    return deck
end

function DeckClass:update()

end

function DeckClass:draw()
    -- Draws transparent grey background
    love.graphics.setColor(0.53, 0.55, 0.55, 0.7)
    love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y, 100, 6)

    -- Draws NOT transparent grey outline
    love.graphics.setColor(0.388, 0.388, 0.388, 1)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", self.position.x, self.position.y, self.size.x, self.size.y, 100, 6)
    love.graphics.setLineWidth(1)
end

function DeckClass:addCard(card)
    table.insert(self.cards, card)
    card.faceDown = true
    card.position = self.position
    card.locked = true
end

function DeckClass:removeCard()
    if #self.cards == 0 or #self.hand.cards >= 7 then return end

    local card = table.remove(self.cards)
    self.hand:addCard(card)
end

function DeckClass:removeOppCard(hand)
    if #self.cards == 0 or #hand.cards >= 7 then return end

    local card = table.remove(self.cards)
    hand:addCard(card)
end

function DeckClass:shuffle()

end

function DeckClass:makeCards()

end

--[[ function DeckClass:isMouseOver()
    local mousePos = grabber.currentMousePos
    local isMouseOver = 
        mousePos.x > self.position.x and
        mousePos.x < self.position.x + self.size.x and
        mousePos.y > self.position.y and
        mousePos.y < self.position.y + self.size.y

    return isMouseOver
end ]]

-- helper function to fix "layer" issue experienced by playSurface in drawing, updating, and checking for mouse over all cards.
function DeckClass:getAllCards()
    return self.cards
end