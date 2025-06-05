require "vector"
require "grabber"
require "card"
require "specialCard"
require "hand"
require "deck"
require "playSpot"
require "discard"
require "playManager"
require "button"

PlaySurfaceClass = {}
PlaySurfaceClass.__index = PlaySurfaceClass

function PlaySurfaceClass:new()
    local playSurface = setmetatable({}, self) 

    -- PlaySpot dimensions are stored here instead of main in order to keep main clean. They aren't stored in playSpot because they are used to determine the playSpots' positions before any of them have been instantiated.
    spotWidth = 335
    spotHeight = 240

    -- cardHomes will store every place that can store cards. Figured it'd be nice to have a place at the top that could be descended down to access any card. Not perfect as lower "branches" can still be accessed from anywhere without using this, but it's helpful. Only annoying thing is I'm pretty sure I need to account for any cards that aren't on the same "level" as the rest
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

    -- Below variables store locations for display hexagons
    playSurface.pPointsHex = nil
    playSurface.pManaHex = nil
    
    playSurface.ePointsHex = nil
    playSurface.pManaHex = nil

    playSurface.pPS1Hex = nil
    playSurface.pPS2Hex = nil
    playSurface.pPS3Hex = nil

    playSurface.ePS1Hex = nil
    playSurface.ePS2Hex = nil
    playSurface.ePS3Hex = nil

    -- Make play manager and submit button
    playSurface.playMan = PlayManClass:new()
    local pHandXY = playSurface.pHand:getCenterPos()
    playSurface.submitButton = ButtonClass:new(pHandXY.x, pHandXY.y - (90), "Submit", playSurface.playMan:playerTurn())

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

    self.submitButton:update()
end

function PlaySurfaceClass:draw()
    -- Drawing hexagons that outline displays of points and mana
    self:drawHexagons()

    -- Drawing nums that go in the hexagons
    self:drawNums()

    -- Drawing submit button
    self.submitButton:draw()
    
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

-- Function to inititate all of the cards. My TODO for this is gonna be huge, but we'll burn that bridge when we get to it. It also adds all of the "homes" to the playSurface's cardHomes list
function PlaySurfaceClass:fillCards()
    local json = require("dkjson")
    local file = love.filesystem.read("cardData.json")
    local data = json.decode(file)

    for i, entry in ipairs(data) do
        local card
        local playerNum = 1 -- or 2 depending on use

        local isSpecial = (entry.type ~= "Vanilla")

        if isSpecial then
            card = SpecialCardClass:new(playerNum, 0, 0, entry.power, entry.cost, entry.name, entry.text, i)
        else
            card = CardClass:new(playerNum, 0, 0, entry.power, entry.cost, entry.name, entry.text, i)
            --card.text = entry.text
        end

        self.pHand:addCard(card)
    end

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

function PlaySurfaceClass:drawHexagons()
    --[[ self.pPointsHex = Vector(PlaySurfaceClass:drawHex(self.pHand:getCenterX() + (self.pHand:getSizeX() * 0.58), self.pHand:getCenterY() - (self.pHand:getSizeY() * 0.2)))
    self.pManaHex = Vector(PlaySurfaceClass:drawHex(self.pHand:getCenterX() + (self.pHand:getSizeX() * 0.58), self.pHand:getCenterY() + (self.pHand:getSizeY() * 0.2)))
 ]]
    -- Drawing player points and mana hexagons to right of hand
    self.pPointsHex = Vector(PlaySurfaceClass:drawHex(self.pHand:getCenterX() + (self.pHand:getSizeX() * 0.58), self.pHand:getCenterY() - (self.pHand:getSizeY() * 0.2)))
    self.pManaHex = Vector(PlaySurfaceClass:drawHex(self.pHand:getCenterX() + (self.pHand:getSizeX() * 0.58), self.pHand:getCenterY() + (self.pHand:getSizeY() * 0.2)))
    
    -- Drawing enemy points and mana hexagons to right of hand
    self.ePointsHex = Vector(PlaySurfaceClass:drawHex(self.eHand:getCenterX() - (self.eHand:getSizeX() * 0.58), self.eHand:getCenterY() + (self.eHand:getSizeY() * 0.2)))
    self.eManaHex = Vector(PlaySurfaceClass:drawHex(self.eHand:getCenterX() - (self.eHand:getSizeX() * 0.58), self.eHand:getCenterY() - (self.eHand:getSizeY() * 0.2)))

    -- Drawing player points per playSpot below each playSpot
    self.pPS1Hex = Vector(PlaySurfaceClass:drawHex(self.playSpot1:getCenterX(), self.playSpot1:getCenterY() + (spotHeight * 0.6)))
    self.pPS2Hex = Vector(PlaySurfaceClass:drawHex(self.playSpot2:getCenterX(), self.playSpot2:getCenterY() + (spotHeight * 0.6)))
    self.pPS3Hex = Vector(PlaySurfaceClass:drawHex(self.playSpot3:getCenterX(), self.playSpot3:getCenterY() + (spotHeight * 0.6)))

    -- Drawing enemy points per playSpot above each playSpot
    self.ePS1Hex = Vector(PlaySurfaceClass:drawHex(self.playSpot1:getCenterX(), self.playSpot1:getCenterY() - (spotHeight * 0.6)))
    self.ePS2Hex = Vector(PlaySurfaceClass:drawHex(self.playSpot2:getCenterX(), self.playSpot2:getCenterY() - (spotHeight * 0.6)))
    self.ePS3Hex = Vector(PlaySurfaceClass:drawHex(self.playSpot3:getCenterX(), self.playSpot3:getCenterY() - (spotHeight * 0.6)))
end

function PlaySurfaceClass:drawNums()
    numFont = love.graphics.newFont("assets/Greek-Freak.ttf", 29)
    love.graphics.setFont(numFont)
    -- Each players' stat nums are drawn below
    -- Draws player points
    love.graphics.setColor(1, 0.878, 0.008, 1)
    text, drawX, drawY = self:drawNumsHelper(self.pHand:getPoints(), self.pPointsHex)
    love.graphics.print(text, drawX, drawY)

    -- Draws player mana
    love.graphics.setColor(0.3, 0.7, 0.9, 1)
    text, drawX, drawY = self:drawNumsHelper(self.pHand:getMana(), self.pManaHex)
    love.graphics.print(text, drawX, drawY)

    -- Draws enemy points
    love.graphics.setColor(1, 0.878, 0.008, 1)
    text, drawX, drawY = self:drawNumsHelper(self.pHand:getPoints(), self.ePointsHex)
    love.graphics.print(text, drawX, drawY)

    -- Draws enemy mana
    love.graphics.setColor(0.3, 0.7, 0.9, 1)
    text, drawX, drawY = self:drawNumsHelper(self.pHand:getMana(), self.eManaHex)
    love.graphics.print(text, drawX, drawY)


    -- The power per player at each location is drawn below
    love.graphics.setColor(0.8, 0, 0, 1)
    -- Draws player power at playSpot 1
    text, drawX, drawY = self:drawNumsHelper(self.playSpot1:getPlayerPowers(), self.pPS1Hex)
    love.graphics.print(text, drawX, drawY)

    -- Draws player power at playSpot 2
    text, drawX, drawY = self:drawNumsHelper(self.playSpot2:getPlayerPowers(), self.pPS2Hex)
    love.graphics.print(text, drawX, drawY)

    -- Draws player power at playSpot 3
    text, drawX, drawY = self:drawNumsHelper(self.playSpot3:getPlayerPowers(), self.pPS3Hex)
    love.graphics.print(text, drawX, drawY)

    -- Draws enemy power at playSpot 1
    text, drawX, drawY = self:drawNumsHelper(self.playSpot1:getEnemyPowers(), self.ePS1Hex)
    love.graphics.print(text, drawX, drawY)

    -- Draws enemy power at playSpot 2
    text, drawX, drawY = self:drawNumsHelper(self.playSpot2:getEnemyPowers(), self.ePS2Hex)
    love.graphics.print(text, drawX, drawY)

    -- Draws enemy power at playSpot 3
    text, drawX, drawY = self:drawNumsHelper(self.playSpot3:getEnemyPowers(), self.ePS3Hex)
    love.graphics.print(text, drawX, drawY)
end

-- Helper function to make drawNums not be 600 lines long
function PlaySurfaceClass:drawNumsHelper(num, hex)
    local text = tostring(num)
    local font = love.graphics.getFont()
    local textWidth = font:getWidth(text)
    local textHeight = font:getHeight()

    local drawX = hex.x - textWidth / 2
    local drawY = hex.y - textHeight / 2 + 2
    
    return text, drawX, drawY
end

-- Draws hexagons that outline the nums that need to be displayed (power, mana, points)
function PlaySurfaceClass:drawHex(x, y)
    local w = 70
    local h = w / 2
   
    local hw = w / 2
    local hh = h / 2

    local dx = hw
    local dy = hh * 0.5

    local points = {
        x,        y - hh,  -- top point
        x + dx,   y - dy,  -- top right
        x + dx,   y + dy,  -- bottom right
        x,        y + hh,  -- bottom point
        x - dx,   y + dy,  -- bottom left
        x - dx,   y - dy   -- top left
    }

    love.graphics.setColor(0.46, 0.46, 0.46, 1)
    love.graphics.polygon("fill", points)

    love.graphics.setColor(0.388, 0.388, 0.388, 1)
    love.graphics.setLineWidth(2)
    love.graphics.polygon("line", points)
    love.graphics.setLineWidth(1)

    return x, y
end