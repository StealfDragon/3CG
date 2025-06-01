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
    playSurface.card3 = CardClass:new(300, 350, 1, 1)
    playSurface.card4 = CardClass:new(900, 350, 1, 1)
    playSurface.tempHand = {}
    playSurface.pHand = HandClass:new(sizeX / 2, sizeY - (sizeY / 9))
    playSurface.pDeck = DeckClass:new(sizeX - sizeX/13, sizeY - (sizeY / 9))
    playSurface.playSpot1 = PlaySpotClass:new((spotWidth / 2) + 2, sizeY / 2)
    playSurface.playSpot2 = PlaySpotClass:new(sizeX / 2, sizeY / 2)
    playSurface.playSpot3 = PlaySpotClass:new(sizeX - ((spotWidth / 2) + 2), sizeY / 2)

    --[[ table.insert(playSurface.cardHomes, playSurface.tempHand)
    table.insert(playSurface.tempHand, playSurface.card1)
    table.insert(playSurface.tempHand, playSurface.card2) ]]

    table.insert(playSurface.pHand.cards, playSurface.card1)
    table.insert(playSurface.pHand.cards, playSurface.card2)
    table.insert(playSurface.pHand.cards, playSurface.card3)
    table.insert(playSurface.pHand.cards, playSurface.card4)
    table.insert(playSurface.cardHomes, playSurface.pHand)



    return playSurface
end

function PlaySurfaceClass:update()
    self:checkMouseMoving()

    local hoveredCard = nil
    for _, home in ipairs(self.cardHomes) do
        for i = #home.cards, 1, -1 do
            local card = home.cards[i]
            if card.state == CARD_STATE.MOUSE_OVER then
                hoveredCard = card
                break
            end
        end
        if hoveredCard then 
            break 
        end
    end

    grabber:update(hoveredCard)
    --[[ for _, home in ipairs(self.cardHomes) do
        for _, card in ipairs(home) do
            card:update()
        end
    end ]]
end

function PlaySurfaceClass:draw()
    self.playSpot1:draw()
    self.playSpot2:draw()
    self.playSpot3:draw()
    self.pHand:draw()
    self.pDeck:draw()

    for _, home in ipairs(self.cardHomes) do
        for _, card in ipairs(home.cards) do
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
        for _, card in ipairs(home.cards) do
            card:checkMouseOver(grabber)
        end
    end
end