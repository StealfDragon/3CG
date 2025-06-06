PlayManClass = {}
PlayManClass.__index = PlayManClass

function PlayManClass:new()
    local playMan = setmetatable({}, self) 

    playMan.discardedNum = 0
    playMan.turnNum = 1
    playMan.extraMana = {0, 0}
    playMan.effects = {}

    -- for reveal logic
    playMan.revealQueue = {}
    playMan.revealTimer = 0
    playMan.revealDelay = 1 -- seconds between reveals
    playMan.revealing = false

    playMan.botTurnDelay = 3 -- seconds
    playMan.botTurnTimer = 0
    playMan.waitingForBot = false
    playMan.botPlaysQueued = {}
    playMan.botPlayDelay = 0
    playMan.botPlayTimer = 0
    playMan.waitingToPlayBotCards = false

    return playMan
end

function PlayManClass:update(dt)
    -- Wait before playing bot cards
    if self.waitingToPlayBotCards then
        self.botPlayTimer = self.botPlayTimer + dt
        if self.botPlayTimer >= self.botPlayDelay then
            self.waitingToPlayBotCards = false
            -- Now play the queued cards
            for _, play in ipairs(self.botPlaysQueued) do
                play.spot:addCard(play.card)
                playSurface.eHand:removeCard(play.card)
            end
            self.botPlaysQueued = {}
            self:queueRevealCards()
        end
        return
    end

    if self.revealing and #self.revealQueue > 0 then
        self.revealTimer = self.revealTimer + dt
        if self.revealTimer >= self.revealDelay then
            local card = table.remove(self.revealQueue, 1)
            card.faceDown = false
            self.revealTimer = 0
        end
    end

    if self.revealing and #self.revealQueue == 0 then
        self.revealing = false
        self:afterTurns()
    end
end

-- end of player turn (player has already placed cards and pressed submit)
function PlayManClass:playerTurn()
    if not playSurface then return end

    -- First, lock all player cards
    for _, home in ipairs(playSurface.cardHomes) do
        if home.cards and home.playerNum == 1 then
            for _, card in ipairs(home.cards) do
                if card ~= grabber.heldObject then
                    card.locked = true
                end
            end
        end
    end

     -- Then, flip only cards on playSpots face-down
    for _, playSpot in ipairs({playSurface.playSpot1, playSurface.playSpot2, playSurface.playSpot3}) do
        for _, card in ipairs(playSpot.cards[1]) do
            if not card.playedPrev then
                card.faceDown = true
                card.playedPrev = true
            end
        end
    end

    self:botTurn()
end

function PlayManClass:botTurn()
    local mana = playSurface.eHand:getMana()
    local hand = playSurface.eHand.cards
    local queuedPlays = {}

    table.sort(hand, function(a, b) return a.cost > b.cost end)

    for _, card in ipairs(hand) do
        if card.cost <= mana then
            local spot = self:getRandomEmptyPlaySpot(card.playerNum)
            if spot then
                table.insert(queuedPlays, {card = card, spot = spot})
                mana = mana - card.cost
            end
        end
    end

    self.botPlaysQueued = queuedPlays
    self.botPlayTimer = 0
    self.botPlayDelay = (#queuedPlays > 0) and 3 or 1
    self.waitingToPlayBotCards = true
end

function PlayManClass:getRandomEmptyPlaySpot(playerNum)
    local candidates = {}

    for _, spot in ipairs({playSurface.playSpot1, playSurface.playSpot2, playSurface.playSpot3}) do
        if #spot.cards[playerNum] < 4 then
            table.insert(candidates, spot)
        end
    end

    if #candidates > 0 then
        return candidates[math.random(1, #candidates)]
    else
        return nil
    end
end

function PlayManClass:queueRevealCards()
   self.revealQueue = {}

    local p1Points = playSurface.pHand:getPoints()
    local p2Points = playSurface.eHand:getPoints()

    local firstPlayer, secondPlayer
    if p1Points > p2Points then
        firstPlayer, secondPlayer = 1, 2
    elseif p2Points > p1Points then
        firstPlayer, secondPlayer = 2, 1
    else
        -- Tie: flip a coin
        if math.random(0, 1) == 0 then
            firstPlayer, secondPlayer = 1, 2
        else
            firstPlayer, secondPlayer = 2, 1
        end
    end

    -- Queue cards to reveal: winner first, then loser
    for _, playSpot in ipairs({playSurface.playSpot1, playSurface.playSpot2, playSurface.playSpot3}) do
        for _, card in ipairs(playSpot.cards[firstPlayer]) do
            if card.faceDown then 
                table.insert(self.revealQueue, card)
            end
        end
        for _, card in ipairs(playSpot.cards[secondPlayer]) do
            if card.faceDown then 
                table.insert(self.revealQueue, card)
            end
        end
    end

    self.revealing = true
    self.revealTimer = 0
end

function PlayManClass:afterTurns()
    for _, card in ipairs(playSurface.pHand.cards) do
        card.locked = false
    end

    self.turnNum = self.turnNum + 1
    playSurface.pHand:setMana(self.turnNum + self.extraMana[1])
    playSurface.eHand:setMana(self.turnNum + self.extraMana[2])
    playSurface.pDeck:removeCard()
    playSurface.eDeck:removeCard()
    playSurface.submitButton.beenPressed = false
end

function PlayManClass:winCondition()

end

-- Function to insantiate game. TODO huge. It also adds all of the "homes" to the playSurface's cardHomes list
function PlayManClass:initiateGame()
    local json = require("dkjson")
    local file = love.filesystem.read("cardData.json")
    local data = json.decode(file)

    --[[ for i, entry in ipairs(data) do
        local card
        -- local playerNum = 1 -- or 2 depending on use

        local isSpecial = (entry.type ~= "Vanilla")

        for playerNum = 1, 2 do
            if isSpecial then
                card = SpecialCardClass:new(playerNum, 0, 0, entry.power, entry.cost, entry.name, entry.text, i)
            else
                card = CardClass:new(playerNum, 0, 0, entry.power, entry.cost, entry.name, entry.text, i)
            end
            if playerNum == 1 then
                playSurface.pDeck:addCard(card)
            else
                playSurface.eDeck:addCard(card)
            end
        end

        --playSurface.pDeck:addCard(card)
    end
    playSurface.pDeck:removeCard()
    playSurface.pDeck:removeCard()
    playSurface.pDeck:removeCard()

    playSurface.eDeck:removeCard()
    playSurface.eDeck:removeCard()
    playSurface.eDeck:removeCard() ]]

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