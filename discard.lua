DiscardClass = {}
DiscardClass.__index = DiscardClass

function DiscardClass:new(xPos, yPos)
    local discardPile = setmetatable({}, self) 

    discardPile.size = Vector(cardWidth, cardHeight)
    discardPile.position = Vector(xPos, yPos) - (discardPile.size * 0.5)
    discardPile.type = "discard"
    
    discardPile.numCards = 0
    discardPile.cards = {}
    discardPile.lowestCard = nil
    discardPile.highestCard = nil

    discardPile.playerNum = nil

    return discardPile
end

function DiscardClass:draw()
    -- Draws transparent red background
    love.graphics.setColor(0.58, 0, 0, 0.7)
    love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y, 100, 6)

    -- Draws NOT transparent grey outline
    love.graphics.setColor(0.388, 0.388, 0.388, 1)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", self.position.x, self.position.y, self.size.x, self.size.y, 100, 6)
    love.graphics.setLineWidth(1)

    local defaultFont = love.graphics.getFont()
    local bigFont = love.graphics.newFont("assets/Greek-Freak.ttf", 80)
    love.graphics.setFont(bigFont)

    love.graphics.setColor(0.388, 0.388, 0.388, 1)
    local text = "D"
    local textWidth = bigFont:getWidth(text)
    local textHeight = bigFont:getHeight(text)
    local centerX = self.position.x + (self.size.x / 2) - (textWidth / 2)
    local centerY = self.position.y + (self.size.y / 2) - (textHeight / 2) + 5

    love.graphics.print(text, centerX, centerY)
    love.graphics.setFont(defaultFont)
end

function DiscardClass:addCard()

end