SpecialCardClass = setmetatable({}, {__index = CardClass})
SpecialCardClass.__index = SpecialCardClass

function SpecialCardClass:new(xPos, yPos, power, cost, text)
    local specialCard = CardClass:new(self, xPos, yPos, power, cost)
    specialCard.text = text

    return specialCard
end

function SpecialCardClass:onX()

end

function SpecialCardClass:setPower()

end

function SpecialCardClass:getPower()

end

function SpecialCardClass:activateAbility()

end