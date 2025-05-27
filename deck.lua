DeckClass = {}
DeckClass.__index = DeckClass

function DeckClass:new()
    local deck = setmetatable({}, self) 

    deck.Cards = {}
    deck.numCards = 0

    return deck
end

function HandClass:getNumCards()

end

function HandClass:draw()

end

function HandClass:shuffle()

end

function HandClass:makeCards()

end