DeckClass = {}
DeckClass.__index = DeckClass

function DeckClass:new(xPos, yPos)
    local deck = setmetatable({}, self) 

    deck.size = Vector(cardWidth, cardHeight)
    deck.position = Vector(xPos, yPos) - (deck.size * 0.5)
    deck.type = "deck"
    deck.hovered = false

    deck.cards = {}
    deck.numCards = 0

    deck.playerNum = nil

    return deck
end

function DeckClass:update()
    self.hovered = self:isMouseOver()

    if love.mouse.isDown(1) and self.hovered and grabber.heldObject == nil and not self.beenPressed then
        
    end

    if not love.mouse.isDown(1) and self.pressed and self.hovered then
        
    end
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

function DeckClass:addCard()

end

function DeckClass:removeCard()

end

function DeckClass:shuffle()

end

function DeckClass:makeCards()

end

-- helper function to fix "layer" issue experienced by playSurface in drawing, updating, and checking for mouse over all cards.
function DeckClass:getAllCards()
    return self.cards
end

function DeckClass:isMouseOver()
    local mousePos = grabber.currentMousePos
    local isMouseOver = 
        mousePos.x > self.position.x and
        mousePos.x < self.position.x + self.size.x and
        mousePos.y > self.position.y and
        mousePos.y < self.position.y + self.size.y

    return isMouseOver
end