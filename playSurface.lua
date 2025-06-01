require "grabber"
require "card"
require "specialCard"
require "hand"
require "deck"
require "playSpot"
require "discard"

PlaySurfaceClass = {}
PlaySurfaceClass.__index = PlaySurfaceClass

function PlaySurfaceClass:new()
    local playSurface = setmetatable({}, self) 

    playSurface.cardHomes = {}
    playSurface.card1 = CardClass:new(500, 350, 1, 1)
    playSurface.card2 = CardClass:new(700, 350, 1, 1)
    playSurface.hand = {}

    table.insert(playSurface.cardHomes, playSurface.hand)
    table.insert(playSurface.hand, playSurface.card1)
    table.insert(playSurface.hand, playSurface.card2)

    return playSurface
end

function PlaySurfaceClass:update()
    self:checkMouseMoving()

    local hoveredCard = nil
    for _, home in ipairs(self.cardHomes) do
        for i = #home, 1, -1 do
            local card = home[i]
            if card.state == CARD_STATE.MOUSE_OVER then
                hoveredCard = card
                break
            end
        end
        if hoveredCard then break end
    end

    grabber:update(hoveredCard)
    --[[ for _, home in ipairs(self.cardHomes) do
        for _, card in ipairs(home) do
            card:update()
        end
    end ]]
end

function PlaySurfaceClass:draw()
    for _, home in ipairs(self.cardHomes) do
        for _, card in ipairs(home) do
            if card ~= grabber.heldObject then
                card:draw()
            end
        end
    end

    if grabber.heldObject then
        grabber.heldObject:draw()
    end
end

function PlaySurfaceClass:checkMouseMoving()
    if grabber.currentMousePos == nil then
        return
    end

    for _, home in ipairs(self.cardHomes) do
        for _, card in ipairs(home) do
            card:checkMouseOver(grabber)
        end
    end
end