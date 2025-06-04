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

    -- PlaySpot dimensions are stored here instead of main in order to keep main clean. They aren't stored in playSpot because they are used to determine the playSpots' positions before any of them have been instantiated.
    spotWidth = 335
    spotHeight = 240

    -- cardHomes will store every place that can store cards. Figured it'd be nice to have a place at the top that could be descended down to access any card. Not perfect as lower "branches" can still be accessed from anywhere without using this, but it's helpful. Only annoying thing is I'm pretty sure I need to keep all of the cards on the same "level" but I'm not 100% sure about that.
    playSurface.cardHomes = {}

    -- The code below initiates every card "home"
    playSurface.playSpot1 = PlaySpotClass:new((spotWidth / 2) + 2, sizeY / 2)
    playSurface.playSpot2 = PlaySpotClass:new(sizeX / 2, sizeY / 2)
    playSurface.playSpot3 = PlaySpotClass:new(sizeX - ((spotWidth / 2) + 2), sizeY / 2)

    playSurface.pHand = HandClass:new(sizeX / 2, sizeY - (sizeY / 9), 1)
    playSurface.pDeck = DeckClass:new(sizeX - sizeX/13, sizeY - (sizeY / 9))
    playSurface.pDiscard = DiscardClass:new(sizeX/13, sizeY - (sizeY / 9), 1)

    playSurface.eHand = HandClass:new(sizeX / 2, sizeY / 9, 2)
    playSurface.eDeck = DeckClass:new(sizeX/13, sizeY / 9)
    playSurface.eDiscard = DiscardClass:new(sizeX - sizeX/13, sizeY / 9, 2)
    -- NOTE: enemy discard and deck x positions flipped

    playSurface:fillCards()

    return playSurface
end

function PlaySurfaceClass:update()
    self:checkMouseMoving()

    -- Checks every card to see if its state has changed, and calls grabber on any hovered card, in order to check for a grab
    local hoveredCard = nil
    for _, home in ipairs(self.cardHomes) do
        local cardList = home.type == "playSpot" and home:getAllCards() or home.cards -- this line checks to see if the home is a playSpot because the playSpot cards are stored one level lower than all the other homes
        for i = #cardList, 1, -1 do
            local card = cardList[i]
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
    -- Drawing all visible card "homes"
    self.playSpot1:draw()
    self.playSpot2:draw()
    self.playSpot3:draw()

    self.pHand:draw()
    self.pDeck:draw()
    self.pDiscard:draw()

    self.eHand:draw()
    self.eDeck:draw()
    self.eDiscard:draw()

    -- Then drawing all cards in those "homes"
    for _, home in ipairs(self.cardHomes) do
        local cardList = home.type == "playSpot" and home:getAllCards() or home.cards -- this line checks to see if the home is a playSpot because the playSpot cards are stored one level lower than all the other homes
        for _, card in ipairs(cardList) do
            if card ~= grabber.heldObject then
                card:draw()
            end
        end
    end

    --[[ if home.type == "playSpot" and card ~= grabber.heldObject then
                for i, v in ipairs(card) do
                    v:draw()
                end
            elseif card ~= grabber.heldObject then
                card:draw()
            end ]]

    -- Draws the held object on top of everything else so that it's never under anything while being moved
    if grabber.heldObject then
        grabber.heldObject:draw()
    end
end

function PlaySurfaceClass:checkMouseMoving()
    if grabber.currentMousePos == nil then
        return
    end

    -- Different check than earlier in update. checkMouseOver doesn't take any actions, its only job is to change a card's state, so this is basically a little helper loop for the "action" loop in update
    for _, home in ipairs(self.cardHomes) do
        local cardList = home.type == "playSpot" and home:getAllCards() or home.cards -- this line checks to see if the home is a playSpot because the playSpot cards are stored one level lower than all the other homes
        for _, card in ipairs(cardList) do
            card:checkMouseOver(grabber)
        end
    end
end

-- Function to inititate all of the cards. My TODO for this is gonna be huge, but we'll burn that bridge when we get to it.
function PlaySurfaceClass:fillCards()
    local card1 = CardClass:new(300, sizeY - (sizeY / 9), 1, 1, 1, 1)
    local card2 = CardClass:new(400, sizeY - (sizeY / 9), 1, 1, 2, 1)
    local card3 = CardClass:new(500, sizeY - (sizeY / 9), 1, 1, 3, 1)
    local card4 = CardClass:new(600, sizeY - (sizeY / 9), 1, 1, 4, 1)

    --[[ table.insert(self.pHand.cards, self.card1)
    table.insert(self.pHand.cards, self.card2)
    table.insert(self.pHand.cards, self.card3)
    table.insert(self.pHand.cards, self.card4) ]]

    self.pHand:addCard(card1)
    self.pHand:addCard(card2)
    self.pHand:addCard(card3)
    self.pHand:addCard(card4)

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