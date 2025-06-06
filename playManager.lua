PlayManClass = {}
PlayManClass.__index = PlayManClass

function PlayManClass:new()
    local playMan = setmetatable({}, self) 

    playMan.discardedNum = 0
    playMan.manaNum = 0
    playMan.extraMana = 0
    playMan.effects = {}

    return playMan
end

-- Function to insantiate game. TODO huge. It also adds all of the "homes" to the playSurface's cardHomes list
function PlayManClass:initiateGame()
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
        end

        playSurface.pDeck:addCard(card)
    end
    playSurface.pDeck:removeCard()
    playSurface.pDeck:removeCard()
    playSurface.pDeck:removeCard()

    table.insert(playSurface.cardHomes, playSurface.playSpot1)
    table.insert(playSurface.cardHomes, playSurface.playSpot2)
    table.insert(playSurface.cardHomes, playSurface.playSpot3)

    table.insert(playSurface.cardHomes, playSurface.pHand)
    table.insert(playSurface.cardHomes, playSurface.pDeck)
    table.insert(playSurface.cardHomes, playSurface.pDiscard)

    table.insert(playSurface.cardHomes, playSurface.eHand)
    table.insert(playSurface.cardHomes, playSurface.eDeck)
    table.insert(playSurface.cardHomes, playSurface.eDiscard)
end

function PlayManClass:shuffle()

end

function PlayManClass:playerTurn()
    if not playSurface then return end

    for _, home in ipairs(playSurface.cardHomes) do
        local cardList = nil

        if home.type == "playSpot" then 
            cardList = home.cards[1]
        elseif home.playerNum == 1 and home.cards then
            cardList = home.cards
        end
        
        if cardList then
            for _, card in ipairs(cardList) do
                if card ~= grabber.heldObject then
                    card.locked = true
                    card.faceDown = true
                end
            end
        end
    end

    self:botTurn()
end

function PlayManClass:botTurn()
    -- randomly plays bot's cards facedown
end

function PlayManClass:revealCards()
   
    -- at end:
        -- unlock cards in player hand
        -- set mana count to turn num
end


function PlayManClass:winCondition()

end