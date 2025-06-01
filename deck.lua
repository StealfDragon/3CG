DeckClass = {}
DeckClass.__index = DeckClass

function DeckClass:new(xPos, yPos)
    local deck = setmetatable({}, self) 

    deck.size = Vector(cardWidth, cardHeight)
    deck.position = Vector(xPos, yPos) - (deck.size * 0.5)

    deck.cards = {}
    deck.numCards = 0

    return deck
end

function DeckClass:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", self.position.x, self.position.y, self.size.x, self.size.y, 100, 6)
end

function DeckClass:getNumCards()

end

function DeckClass:shuffle()

end

function DeckClass:makeCards()

end