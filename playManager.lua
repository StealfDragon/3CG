local CardClass = require("card")
local cardTypes = require("cardTypes")

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

    playMan.observers = {}
    playMan.winNum = 50

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

            if card.cardType and card.cardType.onReveal then
                card:activateOnReveal()
            end
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
                card.locked = true
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
    for _, playSpot in ipairs({playSurface.playSpot1, playSurface.playSpot2, playSurface.playSpot3}) do
        playSpot.playersPowers[1] = 0
        playSpot.playersPowers[2] = 0
        for playerNum = 1, 2 do
            for _, card in ipairs(playSpot.cards[playerNum]) do
                playSpot.playersPowers[playerNum] = playSpot.playersPowers[playerNum] + card.power
            end
        end
    end

    for _, playSpot in ipairs({playSurface.playSpot1, playSurface.playSpot2, playSurface.playSpot3}) do
        for playerNum = 1, 2 do
            for _, card in ipairs(playSpot.cards[playerNum]) do
                if card.cardType and card.cardType.onEndOfTurn then
                    card:activateOnEndOfTurn()
                end
            end
        end
    end

    for _, playSpot in ipairs({playSurface.playSpot1, playSurface.playSpot2, playSurface.playSpot3}) do
        for playerNum = 1, 2 do
            for _, card in ipairs(playSpot.cards[playerNum]) do
                if card.cardType and card.cardType.onEndOfTurn then
                    playSpot.playersPowers[playerNum] = playSpot.playersPowers[playerNum] + (card.power - card.prePower)
                end
            end
        end
    end

    for _, playSpot in ipairs({playSurface.playSpot1, playSurface.playSpot2, playSurface.playSpot3}) do
        local p1Power = playSpot.playersPowers[1]
        local p2Power = playSpot.playersPowers[2]

        if p1Power > p2Power then
            playSurface.pHand.points = playSurface.pHand.points + (p1Power - p2Power)
        elseif p2Power > p1Power then
            playSurface.eHand.points = playSurface.eHand.points + (p2Power - p1Power)
        end
    end

    winner = self:winCondition(playSurface.pHand.points, playSurface.eHand.points)
    if winner then
        self:notifyWin(winner)
    end

    for _, card in ipairs(playSurface.pHand.cards) do
        card.locked = false
    end

    self.turnNum = self.turnNum + 1
    playSurface.pHand:setMana(self.turnNum + self.extraMana[1])
    playSurface.eHand:setMana(self.turnNum + self.extraMana[2])
    playSurface.pDeck:removeCard()
    playSurface.eDeck:removeCard()
    playSurface.submitButton.beenPressed = false
    self.extraMana = {0, 0}
end

function PlayManClass:winCondition(p1Points, p2Points)
    local winner = nil
    if p1Points > self.winNum and p2Points > self.winNum then
        if p1Points > p2Points then winner = 1
        elseif p2Points > p1Points then winner = 2 end
    elseif p1Points >= self.winNum then winner = 1
    elseif p2Points >= self.winNum then winner = 2 end
    return winner
end

-- Function to insantiate game. TODO huge. It also adds all of the "homes" to the playSurface's cardHomes list
function PlayManClass:initiateGame()
    local pDeck = self:buildDeck(1)
    for _, card in ipairs(pDeck) do
        playSurface.pDeck:addCard(card)
    end

    local eDeck = self:buildDeck(2)
    for _, card in ipairs(eDeck) do
        playSurface.eDeck:addCard(card)
    end

    playSurface.pDeck:removeCard()
    playSurface.pDeck:removeCard()
    playSurface.pDeck:removeCard()

    playSurface.eDeck:removeCard()
    playSurface.eDeck:removeCard()
    playSurface.eDeck:removeCard()

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

function PlayManClass:buildDeck(playerNum)
    local json = require("dkjson")
    local file = love.filesystem.read("cardData.json")
    local data = json.decode(file)

    local vanillaCards = {}
    local specialCards = {}

    for _, cardData in ipairs(data) do
        local entry = {
            name = cardData.name,
            cost = cardData.cost,
            power = cardData.power,
            text = cardData.text,
            type = cardData.type
        }

        if cardTypes[cardData.name] then
            local cardType = cardTypes[cardData.name]
            entry.onReveal = cardType.onReveal
            entry.onEndOfTurn = cardType.onEndOfTurn or cardType.onEoT
        end

        if cardData.type == "1" then
            table.insert(vanillaCards, entry)
        elseif cardData.type == "2" then
            table.insert(specialCards, entry)
        end
    end

    local deckTypes = {}
    local counts = {}

    while #deckTypes < 4 do
        local pick = vanillaCards[math.random(#vanillaCards)]
        if not counts[pick.name] then
            table.insert(deckTypes, pick)
            counts[pick.name] = 1
        end
    end

    -- Pick 10 unique special cards
    while #deckTypes < 14 do
        local pick = specialCards[math.random(#specialCards)]
        if not counts[pick.name] then
            table.insert(deckTypes, pick)
            counts[pick.name] = 1
        end
    end

    -- Add 6 random duplicates (max 2 copies total per card)
    local allCards = {}
    for _, card in ipairs(vanillaCards) do table.insert(allCards, card) end
    for _, card in ipairs(specialCards) do table.insert(allCards, card) end

    while #deckTypes < 20 do
        local pick = allCards[math.random(#allCards)]
        if (counts[pick.name] or 0) < 2 then
            table.insert(deckTypes, pick)
            counts[pick.name] = (counts[pick.name] or 0) + 1
        end
    end

    self:shuffle(deckTypes)

    local deck = {}
    for _, ctype in ipairs(deckTypes) do
        local card = CardClass:new(playerNum, 0, 0, ctype.power, ctype.cost, ctype.name, ctype.text, 0, ctype)
        table.insert(deck, card)
    end

    return deck
end

function PlayManClass:shuffle(deck)
    for i = #deck, 2, -1 do
        local j = math.random(1, i)
        deck[i], deck[j] = deck[j], deck[i]
    end
end

function PlayManClass:subscribe(observer)
    table.insert(self.observers, observer)
end

function PlayManClass:notifyWin(winner)
    for _, observer in ipairs(self.observers) do
        if observer.onGameWon then
            observer:onGameWon(winner)
        end
    end
end