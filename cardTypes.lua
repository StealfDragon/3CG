cardTypes = {}

cardTypes["Ares"] = {
    name = "Ares",
    onReveal = function(self, playSpot)
        local enemyCards = #playSpot.cards[3 - self.playerNum]
        self.power = self.power + 2 * enemyCards
    end
}

cardTypes["Artemis"] = {
    name = "Artemis",
    onReveal = function(self, playSpot)
        if #playSpot.cards[3 - self.playerNum] == 1 then
            self.power = self.power + 5
        end
    end
}

cardTypes["Hera"] = {
    name = "Hera",
    onReveal = function(self)
        local hand = (self.playerNum == 1) and playSurface.pHand or playSurface.eHand
        for _, card in ipairs(hand.cards) do
            card.power = card.power + 1
        end
    end
}

cardTypes["Demeter"] = {
    name = "Demeter",
    onReveal = function(self)
        playSurface.pDeck:removeCard()
        playSurface.eDeck:removeCard()
    end
}

cardTypes["Hercules"] = {
    name = "Hercules",
    onReveal = function(self, playSpot)
        self.prePower = self.power
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
    onReveal = function(self)
        local copy = CardClass:new(self.playerNum, 0, 0, self.power + 1, self.cost, self.name, self.text, self.num)
        copy.cardType = cardTypes[self.name]
        local hand = (self.playerNum == 1) and playSurface.pHand or playSurface.eHand
        hand:addCard(copy)
    end
}

cardTypes["Damocles"] = {
    name = "Damocles",
    onEndOfTurn = function(self, playSpot)
        self.prePower = self.power
        local myPower = playSpot.playersPowers[self.playerNum]
        local enemyPower = playSpot.playersPowers[3 - self.playerNum]
        if enemyPower > myPower then
            self.power = self.power - 1
        end
    end
}

cardTypes["Midas"] = {
    name = "Midas",
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
    onReveal = function(self)
        playMan.extraMana[self.playerNum] = playMan.extraMana[self.playerNum] + 1
    end
}

cardTypes["Prometheus"] = {
    name = "Prometheus",
    onReveal = function(self)
        local oppDeck = (self.playerNum == 1) and playSurface.eDeck or playSurface.pDeck
        local oppHand = (self.playerNum == 1) and playSurface.pHand or playSurface.eHand
        oppDeck:removeOppCard(oppHand)
    end
}


cardTypes["Aphrodite"] = {
    name = "Aphrodite",
    onReveal = function(self, playSpot)
        for _, enemyCard in ipairs(playSpot.cards[3 - self.playerNum]) do
            if not enemyCard.faceDown then
                enemyCard.power = enemyCard.power - 1
            end
        end
    end
}

cardTypes["Atlas"] = {
    name = "Atlas",
    onEndOfTurn = function(self, playSpot)
        self.prePower = self.power
        if #playSpot.cards[self.playerNum] >= 4 then
            self.power = self.power - 1
        end
    end
}

cardTypes["Helios"] = {
    name = "Helios",
    onEndOfTurn = function(self, playSpot)
        self.prePower = self.power
        self:discard()
    end
}

cardTypes["Mnemosyne"] = {
    name = "Mnemosyne",
    onReveal = function(self)
        local hand = (self.playerNum == 1) and playSurface.pHand or playSurface.eHand
        local lastPlayed = hand.lastPlayed

        if lastPlayed and lastPlayed.name ~= "Mnemosyne" then
            local copy = CardClass:new(self.playerNum, 0, 0, lastPlayed.power, lastPlayed.cost, lastPlayed.name, lastPlayed.text, lastPlayed.num)
            copy.cardType = lastPlayed.cardType
            hand:addCard(copy)
        end
    end
}

cardTypes["Zeus"] = {
    name = "Zeus",
    onReveal = function(self)
        local enemyHand = (self.playerNum == 1) and playSurface.eHand or playSurface.pHand
        for _, card in ipairs(enemyHand.cards) do
            card.power = card.power - 1
        end
    end
}

cardTypes["Nyx"] = {
    name = "Nyx",
    onReveal = function(self, playSpot)
        local newPower = self.power
        local i = #playSpot.cards[self.playerNum]
        while i >= 1 do
            local card = playSpot.cards[self.playerNum][i]
            if card ~= self then
                newPower = newPower + card.power
                playSpot:removeCard(card)
                card:discard()
            end
            i = i - 1
        end
        self.power = newPower
    end
}

return cardTypes