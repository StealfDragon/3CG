require "vector"

ButtonClass = {}
ButtonClass.__index = ButtonClass

function ButtonClass:new(x, y, text, onClick)
    local button = setmetatable({}, self)

    button.width = 90
    button.height = 35
    button.size = Vector(button.width, button.height)
    button.position = Vector(x, y) - (button.size * 0.5)
    button.text = text
    button.onClick = onClick or function() end

    button.hovered = false
    button.pressed = false
    button.beenPressed = false

    return button
end

function ButtonClass:update(mouseX, mouseY)
    self.hovered = self:isMouseOver()

    if love.mouse.isDown(1) and self:isMouseOver(x, y) and grabber.heldObject == nil and not self.beenPressed then
        self.pressed = true
    end

    if not love.mouse.isDown(1) and self.pressed and self:isMouseOver(x, y) then
        self.onClick()
        self.pressed = false
        self.beenPressed = true
    end
end

function ButtonClass:draw()
    -- Background
    love.graphics.setColor(0.46, 0.46, 0.46)
    love.graphics.rectangle("fill", self.position.x, self.position.y, self.width, self.height, 8, 8)

    -- Outline
    love.graphics.setLineWidth(2)
    if self.pressed then
        love.graphics.setColor(0, 0, 0)
    elseif self.hovered and not self.beenPressed then
        love.graphics.setColor(0.16, 0.89, 0.184)
    else
        love.graphics.setColor(0.388, 0.388, 0.388)
    end
    love.graphics.rectangle("line", self.position.x, self.position.y, self.width, self.height, 8, 8)
    love.graphics.setLineWidth(1)

    -- Text
    love.graphics.setColor(1, 1, 1)
    local font = love.graphics.getFont()
    local textWidth = font:getWidth(self.text)
    local textHeight = font:getHeight()
    local tx = self.position.x + (self.width - textWidth) / 2
    local ty = self.position.y + (self.height - textHeight) / 2
    love.graphics.print(self.text, math.floor(tx + 0.5), math.floor(ty + 0.5))
end

function ButtonClass:isMouseOver()
    local mousePos = grabber.currentMousePos
    local isMouseOver = 
        mousePos.x > self.position.x and
        mousePos.x < self.position.x + self.size.x and
        mousePos.y > self.position.y and
        mousePos.y < self.position.y + self.size.y

    return isMouseOver
end