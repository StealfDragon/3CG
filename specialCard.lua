SpecialCardClass = setmetatable({}, {__index = CardClass})
SpecialCardClass.__index = SpecialCardClass

function SpecialCardClass:new(playerNum, xPos, yPos, power, cost, name, text, num)
    local specialCard = CardClass:new(self, playerNum, xPos, yPos, power, cost, name, text, num)

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

function SpecialCardClass:moveLocation()

end

function SpecialCardClass:copy()

end