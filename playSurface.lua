require "grabber"
require "card"
requie "specialCard"
require "hand"
require "deck"
require "playSpot"
require "discard"

PlaySurfaceClass = {}
PlaySurfaceClass.__index = PlaySurfaceClass

function PlaySurfaceClass:new()
    local playSurface = setmetatable({}, self) 

    grabber = GrabberClass:new()
    cardHomes = {}

end

function PlaySurfaceClass:update()
    grabber:update()
    checkMouseMoving()
end

function PlaySurfaceClass:draw()

end

function PlaySurfaceClass:checkMouseMoving()
    if grabber.currentMousePos == nil then
        return
    end

    for _, card in ipairs(cardTable) do
        card:checkForMouseOver(grabber)
    end
end