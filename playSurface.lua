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

    spotWidth = 335
    spotHeight = 240

    playSurface.cardHomes = {}

    playSurface.playSpot1 = PlaySpotClass:new((spotWidth / 2) + 2, sizeY / 2)
    playSurface.playSpot2 = PlaySpotClass:new(sizeX / 2, sizeY / 2)
    playSurface.playSpot3 = PlaySpotClass:new(sizeX - ((spotWidth / 2) + 2), sizeY / 2)

    playSurface.pHand = HandClass:new(sizeX / 2, sizeY - (sizeY / 9), 1)
    playSurface.pDeck = DeckClass:new(sizeX - sizeX/13, sizeY - (sizeY / 9))
    playSurface.pDiscard = DiscardClass:new(sizeX/13, sizeY - (sizeY / 9))

    playSurface.eHand = HandClass:new(sizeX / 2, sizeY / 9, 2)
    playSurface.eDeck = DeckClass:new(sizeX/13, sizeY / 9)
    playSurface.eDiscard = DiscardClass:new(sizeX - sizeX/13, sizeY / 9)
    -- NOTE: enemy discard and deck x positions flipped

    playSurface:fillCards()

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
end

function PlaySurfaceClass:draw()
    self.playSpot1:draw()
    self.playSpot2:draw()
    self.playSpot3:draw()

    self.pHand:draw()
    self.pDeck:draw()
    self.pDiscard:draw()

    self.eHand:draw()
    self.eDeck:draw()
    self.eDiscard:draw()

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

function PlaySurfaceClass:fillCards()
    self.card1 = CardClass:new(300, sizeY - (sizeY / 9), 1, 1, 1, 1)
    self.card2 = CardClass:new(400, sizeY - (sizeY / 9), 1, 1, 2, 1)
    self.card3 = CardClass:new(500, sizeY - (sizeY / 9), 1, 1, 3, 1)
    self.card4 = CardClass:new(600, sizeY - (sizeY / 9), 1, 1, 4, 1)

    table.insert(self.pHand.cards, self.card1)
    table.insert(self.pHand.cards, self.card2)
    table.insert(self.pHand.cards, self.card3)
    table.insert(self.pHand.cards, self.card4)

    table.insert(self.cardHomes, self.playSpot1)
    table.insert(self.cardHomes, self.playSpot2)
    table.insert(self.cardHomes, self.playSpot3)

    table.insert(self.cardHomes, self.pHand)
    table.insert(self.cardHomes, self.pDeck)
    table.insert(self.cardHomes, self.pDiscard)

    table.insert(self.cardHomes, self.eHand)
    table.insert(self.cardHomes, self.eDeck)
    table.insert(self.cardHomes, self.eDiscard)
end