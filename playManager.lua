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

function PlayManClass:initiateGame()

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
                    -- TODO
                    --
                    --
                    -- card.faceDown = true
                    --
                    --
                    -- END
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