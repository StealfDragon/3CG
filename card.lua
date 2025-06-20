require "vector"

CardClass = {}
CardClass.__index = CardClass

CARD_STATE = { -- stores possible card states
    IDLE = 0,
    MOUSE_OVER = 1,
    GRABBED = 2,
}

function CardClass:new(playerNum, xPos, yPos, power, cost, name, text, num, cardType)
    local card = setmetatable({}, self) 

    card.size = Vector(cardWidth, cardHeight)
    card.position = Vector(xPos, yPos) - (card.size * 0.5)

    card.playerNum = playerNum
    card.power = power
    card.cost = cost
    card.name = name or ""
    card.text = text or ""

    card.faceDown = true
    card.state = CARD_STATE.IDLE
    card.home = nil
    card.discarded = false
    card.locked = false
    if playerNum == 2 then
        card.locked = true
    end
    card.playedPrev = false
    card.wasInHand = false

    card.cardType = cardType or nil

    return card
end

function CardClass:update()

end

function CardClass:draw()
    local x = math.floor(self.position.x + 0.5)
    local y = math.floor(self.position.y + 0.5)
    local w = self.size.x
    local h = self.size.y

    if not self.faceDown then
        -- Highlight if hovered or grabbed
        if self.state == CARD_STATE.MOUSE_OVER and not self.locked and self.home.type == "hand" then
            love.graphics.setColor(0.337, 0.682, 1, 0.8)
            local bottomY = y + h
            w = w * 3
            h = h * 3
            x = x + (self.size.x / 2) - (w / 2)
            y = bottomY - h
            local offset = 6 -- Change
            local halfOffset = offset / 2
            love.graphics.rectangle("fill", x - halfOffset, y - halfOffset, w + offset, h + offset, 100, 6)
        elseif self.state == CARD_STATE.GRABBED and not self.locked then
            love.graphics.setColor(0.16, 0.89, 0.184, 0.8)
            w = self.size.x
            h = self.size.y
            local offset = 6
            local halfOffset = offset / 2
            love.graphics.rectangle("fill", x - halfOffset, y - halfOffset, w + offset, h + offset, 100, 6)
        elseif self.state ~= CARD_STATE.IDLE and not self.locked and self.home.type == "playSpot" then
            love.graphics.setColor(0.16, 0.89, 0.184, 0.8)
            local offset = 6
            local halfOffset = offset / 2
            love.graphics.rectangle("fill", x - halfOffset, y - halfOffset, w + offset, h + offset, 100, 6)
        end

        -- Draws parchment-colored background
        love.graphics.setColor(0.9, 0.89, 0.83, 1)
        love.graphics.rectangle("fill", x, y, w, h, 100, 6)

        -- Draws grey outline
        love.graphics.setColor(0.388, 0.388, 0.388, 1)
        love.graphics.setLineWidth(2)
        love.graphics.rectangle("line", x, y, w, h, 100, 6)
        love.graphics.setLineWidth(1)

        -- Draw the card's text content
        self:drawText(x, y, w, h, w / self.size.x)
    else
        love.graphics.setColor(0.388, 0.388, 0.388, 1)
        love.graphics.rectangle("fill", x, y, w, h, 100, 6)

        love.graphics.setLineWidth(3)
        love.graphics.setColor(0.25, 0.25, 0.25, 1)
        love.graphics.rectangle("line", x, y, w, h, 100, 6)
        love.graphics.setLineWidth(2)

        local defaultFont = love.graphics.getFont()
        local bigFont = love.graphics.newFont("assets/Greek-Freak.ttf", 80)
        bigFont:setFilter("nearest", "nearest")
        love.graphics.setFont(bigFont)

        local text = "m"
        local textWidth = bigFont:getWidth(text)
        local textHeight = bigFont:getHeight(text)
        local centerX = self.position.x + (self.size.x / 2) - (textWidth / 2)
        local centerY = self.position.y + (self.size.y / 2) - (textHeight / 2) + 5

        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.print(text, centerX + 3, centerY + 3)

        love.graphics.setColor(1, 0.878, 0.008, 1)
        love.graphics.print(text, centerX - 1, centerY - 1)
        love.graphics.setFont(defaultFont)
    end
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

function CardClass:activateOnReveal()
    if self.cardType and self.cardType.onReveal then
        local foundPlaySpot = nil
        for _, spot in ipairs({playSurface.playSpot1, playSurface.playSpot2, playSurface.playSpot3}) do
            for _, card in ipairs(spot.cards[self.playerNum]) do
                if card == self then
                    foundPlaySpot = spot
                    break
                end
            end
        end
        self.cardType.onReveal(self, foundPlaySpot)
    end
end

function CardClass:activateOnEndOfTurn()
    if self.cardType and self.cardType.onEndOfTurn then
        local foundPlaySpot = nil
        for _, spot in ipairs({playSurface.playSpot1, playSurface.playSpot2, playSurface.playSpot3}) do
            for _, card in ipairs(spot.cards[self.playerNum]) do
                if card == self then
                    foundPlaySpot = spot
                    break
                end
            end
        end

        self.cardType.onEndOfTurn(self, foundPlaySpot)
    end
end

function CardClass:discard()
    self.discarded = true
    self.faceDown = true
    self.locked = true

    if self.home and self.home.removeCard then
        self.home:removeCard(self)
    end

    local discardPile = (self.playerNum == 1) and playSurface.pDiscard or playSurface.eDiscard
    table.insert(discardPile.cards, self)
    self.position = discardPile.position
    self.home = discardPile
end

function CardClass:drawText(x, y, w, h, scale)
    local name = self.name or ""
    local text = self.text or ""
    local power = tostring(self.power or "")
    local cost = tostring(self.cost or "")

    local padding = 8
    local bodyPadding = 3
    local contentWidth = w - 2 * padding

    local titleMaxSize = math.floor(18 * scale)
    local titleMinSize = math.floor(12 * scale)
    local minSize = math.floor(9 * scale)
    local powerFontSize = math.floor(16 * scale)
    local bodyFontSize = math.floor(12 * scale)

    local powerFont = love.graphics.newFont("assets/Greek-Freak.ttf", powerFontSize)
    powerFont:setFilter("nearest", "nearest")
    local bodyFont = love.graphics.newFont(minSize)
    bodyFont:setFilter("nearest", "nearest")

    -- === Draw Title (Always One Line, Shrunk if Needed) ===
    local titleFont = love.graphics.newFont("assets/Greek-Freak.ttf", titleMaxSize)
    love.graphics.setFont(titleFont)
    titleFont:setFilter("nearest", "nearest")

    local titleWidth = titleFont:getWidth(name)
    while titleWidth > contentWidth and titleFont:getHeight() > titleMinSize do
        local newSize = titleFont:getHeight() - 1
        titleFont = love.graphics.newFont("assets/Greek-Freak.ttf", newSize)
        love.graphics.setFont(titleFont)
        titleWidth = titleFont:getWidth(name)
    end

    local titleY = y + padding
    local titleX = x + (w - titleWidth) / 2

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print(name, math.floor(titleX + 0.5), math.floor(titleY + 0.5))

    -- === Draw Power and Cost ===
    local statY = y + h * 0.25  -- Constant Y, above halfway
    love.graphics.setFont(powerFont)

    love.graphics.setColor(0.9, 0, 0, 1)
    love.graphics.printf(power, x + padding, statY, contentWidth, "left")

    --love.graphics.setColor(0.4, 0.6, 1, 1)
    love.graphics.setColor(0.3, 0.7, 0.9, 1)
    love.graphics.printf(cost, x + padding, statY, contentWidth, "right")

    -- === Draw Description Text ===
    local bodyY = y + h * 0.4
    local descHeight = h - (bodyY - y) - padding

    love.graphics.setFont(bodyFont)
    love.graphics.setColor(0, 0, 0, 1)

    --local _, wrappedLines = bodyFont:getWrap(text, contentWidth)
    local bodyWidth = w - 2 * bodyPadding
    local _, wrappedLines = bodyFont:getWrap(text, bodyWidth)
    local lineHeight = bodyFont:getHeight()
    local maxLines = math.floor(descHeight / lineHeight)

    for i = 1, math.min(#wrappedLines, maxLines) do
        local line = wrappedLines[i]
        love.graphics.print(line, math.floor(x + bodyPadding + 0.5), math.floor(bodyY + (i - 1) * lineHeight + 0.5))
    end
end

return CardClass