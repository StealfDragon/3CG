CardClass = {}
CardClass.__index = CardClass

CARD_STATE = { -- stores possible card states
    IDLE = 0,
    MOUSE_OVER = 1,
    GRABBED = 2,
    DISCARDED = 3
}

function CardClass:new(xPos, yPos, power, cost)
    local card = setmetatable({}, self) 

    card.position = Vector(xPos - cardWidth, yPos - cardHeight)
    card.size = Vector(cardWidth, cardHeight)

    card.power = power
    card.cost = cost
    card.flipped = false
    card.state = CARD_STATE.IDLE
    card.spot = nil

    return card
end

function CardClass:update()

end

function CardClass:draw()

end

function CardClass:checkMouseOver()

end

function CardClass:setCost()

end

function CardClass:setPower()

end

function CardClass:setSpot()

end

function CardClass:attack()

end

function CardClass:discard()

end

function CardClass:moveLocation()

end

function CardClass:copy()

end