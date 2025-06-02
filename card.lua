require "vector"

CardClass = {}
CardClass.__index = CardClass

CARD_STATE = { -- stores possible card states
    IDLE = 0,
    MOUSE_OVER = 1,
    GRABBED = 2,
    DISCARDED = 3
}

function CardClass:new(xPos, yPos, power, cost, num)
    local card = setmetatable({}, self) 

    card.position = Vector(xPos, yPos)--Vector(xPos - cardWidth, yPos - cardHeight)
    card.size = Vector(cardWidth, cardHeight)

    card.num = num
    card.power = power
    card.cost = cost
    card.flipped = false
    card.state = CARD_STATE.IDLE
    card.spot = nil

    return card
end

function CardClass:update()
    --[[ if self.state == CARD_STATE.MOUSE_OVER or CARD_STATE.GRABBED then
        grabber:update(self)
    else
        grabber:update(nil)
    end ]]
end

function CardClass:draw()
    if self.state ~= CARD_STATE.IDLE then
        love.graphics.setColor(0.16, 0.89, 0.184, 0.8) -- color values [0, 1]
        local offset = 6
        local halfOffset = offset / 2.0
        love.graphics.rectangle("fill", self.position.x - halfOffset, self.position.y - halfOffset, self.size.x + offset, self.size.y + offset, 100, 6)
    end
  
    love.graphics.setColor(0.9, 0.89, 0.83, 1)
    love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y, 100, 6)

    love.graphics.setColor(0.388, 0.388, 0.388, 1)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", self.position.x, self.position.y, self.size.x, self.size.y, 100, 6)

    love.graphics.setLineWidth(1)

    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.print(tostring(self.state), self.position.x + 10, self.position.y + 10)

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print(tostring(self.num), self.position.x + self.size.x / 2, self.position.y + self.size.x / 2)
end

function CardClass:checkMouseOver(grabber)
    if grabber.heldObject ~= nil then
        return
    end
    if self.state == CARD_STATE.GRABBED then
        return
    end
        
    local mousePos = grabber.currentMousePos
    local isMouseOver = 
        mousePos.x > self.position.x and
        mousePos.x < self.position.x + self.size.x and
        mousePos.y > self.position.y and
        mousePos.y < self.position.y + self.size.y
    
    self.state = isMouseOver and CARD_STATE.MOUSE_OVER or CARD_STATE.IDLE
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