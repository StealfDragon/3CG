cardTypes = {}

cardTypes["Ares"] = {
    name = "Ares",
    --[[ cost = 8,
    power = 4,
    text = "On Reveal: Gain +2 power for each enemy card here.", ]]
    onReveal = function(self, playSpot)
        local enemyCards = #playSpot.cards[3 - self.playerNum]
        self.power = self.power + 2 * enemyCards
    end
}

cardTypes["Artemis"] = {
    name = "Artemis",
    --[[ cost = 5,
    power = 5,
    text = "On Reveal: Gain +5 power if there is exactly one enemy card here.", ]]
    onReveal = function(self, playSpot)
        if #playSpot.cards[3 - self.playerNum] == 1 then
            self.power = self.power + 5
        end
    end
}

cardTypes["Hera"] = {
    name = "Hera",
    --[[ cost = 8,
    power = 3,
    text = "On Reveal: Give cards in your hand +1 power.", ]]
    onReveal = function(self)
        local hand = (self.playerNum == 1) and playSurface.pHand or playSurface.eHand
        for _, card in ipairs(hand.cards) do
            card.power = card.power + 1
        end
    end
}

cardTypes["Demeter"] = {
    name = "Demeter",
    --[[ cost = 4,
    power = 2,
    text = "On Reveal: Both players draw a card.", ]]
    onReveal = function(self)
        playSurface.pDeck:removeCard()
        playSurface.eDeck:removeCard()
    end
}

cardTypes["Hercules"] = {
    name = "Hercules",
    --[[ cost = 6,
    power = 8,
    text = "On Reveal: Doubles its power if it's the strongest card here.", ]]
    onReveal = function(self, playSpot)
        local strongest = true
        for i = 1, 2 do
            for _, card in ipairs(playSpot.cards[i]) do
                if card ~= self and not card.faceDown and card.power >= self.power then
                    strongest = false
                    break
                end
            end
        end
        if strongest then
            self.power = self.power * 2
        end
    end
}

cardTypes["Theseus' Ship"] = {
    name = "Theseus' Ship",
    --[[ cost = 4,
    power = 4,
    text = "On Reveal: Add a copy with +1 power to your hand.", ]]
    onReveal = function(self)
        local copy = CardClass:new(self.playerNum, 0, 0, self.power + 1, self.cost, self.name, self.text, self.num)
        copy.cardType = cardTypes[self.name]
        local hand = (self.playerNum == 1) and playSurface.pHand or playSurface.eHand
        hand:addCard(copy)
    end
}

cardTypes["Damocles"] = {
    name = "Damocles",
    --[[ cost = 5,
    power = 10,
    text = "EoT: Loses 1 power if not winning this location.", ]]
    onEndOfTurn = function(self, playSpot)
        local myPower = playSpot.playersPowers[self.playerNum]
        local enemyPower = playSpot.playersPowers[3 - self.playerNum]
        if myPower <= enemyPower then
            self.power = self.power - 1
        end
    end
}

cardTypes["Midas"] = {
    name = "Midas",
    --[[ cost = 7,
    power = 1,
    text = "On Reveal: Set ALL cards here to 3 power.", ]]
    onReveal = function(self, playSpot)
        for i = 1, 2 do
            for _, card in ipairs(playSpot.cards[i]) do
                card.power = 3
            end
        end
    end
}

cardTypes["Apollo"] = {
    name = "Apollo",
    --[[ cost = 3,
    power = 2,
    text = "On Reveal: Gain +1 mana next turn.", ]]
    onReveal = function(self)
        playMan.extraMana[self.playerNum] = playMan.extraMana[self.playerNum] + 1
    end
}

cardTypes["Prometheus"] = {
    name = "Prometheus",
    --[[ cost = 4,
    power = 0,
    text = "On Reveal: Draw a card from your opponent's deck.", ]]
    onReveal = function(self)
        local oppDeck = (self.playerNum == 1) and playSurface.eDeck or playSurface.pDeck
        local oppHand = (self.playerNum == 1) and playSurface.pHand or playSurface.eHand
        oppDeck:removeOppCard(oppHand)
    end
}

return cardTypes