HandClass = {}
HandClass.__index = HandClass

function HandClass:new()
    local hand = setmetatable({}, self) 

    hand.Cards = {}
    hand.numCards = 0
    hand.lastPlayed = nil
    hand.lowestCard = nil
    hand.highestCard = nil
    hand.mana = 0
    hand.extraMana = 0

    return hand
end

function HandClass:getNumCards()

end

function HandClass:setCosts()

end

function HandClass:setPowers()

end

function HandClass:reduceMana()

end