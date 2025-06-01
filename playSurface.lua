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
    playSurface.card = CardClass:new(500, 350, 1, 1)

    return playSurface
end

function PlaySurfaceClass:update()
    self:checkMouseMoving()
    self.card:update()
end

function PlaySurfaceClass:draw()
    self.card:draw()
end

function PlaySurfaceClass:checkMouseMoving()
    if grabber.currentMousePos == nil then
        return
    end

    self.card:checkMouseOver(grabber)

    -- UPDATE BELOW TO ACTUALLY WORK
    --[[ for _, card in ipairs(cardTable) do
        card:checkMouseOver(grabber)
    end ]]
end