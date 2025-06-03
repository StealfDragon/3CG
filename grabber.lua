require "vector"

GrabberClass = {}

function GrabberClass:new()
    local grabber = {}
    local metadata = {__index = GrabberClass}
    setmetatable(grabber, metadata)
    
    grabber.previousMousePos = nil
    grabber.currentMousePos = nil
    
    grabber.grabPos = nil
    
    grabber.heldObject = nil
    
    return grabber
end

function GrabberClass:update(card)
    self.currentMousePos = Vector(
        love.mouse.getX(),
        love.mouse.getY()
    )
    
    -- Click (just the first frame)
    if love.mouse.isDown(1) and self.grabPos == nil and card ~= nil then
        self:grab(card)
    end
    -- Release
    if not love.mouse.isDown(1) and self.grabPos ~= nil then
        self:release()
    end  

    if self.heldObject then
        self.heldObject.position = self.currentMousePos - self.highlightOffset
    end
end

function GrabberClass:grab(card)
    self.grabPos = card.position--self.currentMousePos
    self.highlightOffset = self.currentMousePos - card.position
    print("GRAB - " .. tostring(self.grabPos))

    if self.heldObject == nil then
        self.heldObject = card
        self.heldObject.state = CARD_STATE.GRABBED
    end
end

function GrabberClass:release()
    print("RELEASE - ")
    if self.heldObject == nil then -- we have nothing to release
        return
    end

    local isValid, target = self:isValidRelease()
    -- return the heldObject to the grabPosition
    if not isValid then
        self.heldObject.position = self.grabPos
    else
        target:addCard(self.heldObject)
    end


    -- below line is important, because changing the card's state is what actually stops it being grabbed
    self.heldObject.state = 0

    self.heldObject = nil
    self.grabPos = nil
    self.highlightOffset = nil
end

function GrabberClass:isValidRelease()
    local isValidReleasePos = false
    local releaseLocation = nil

    -- Checks all possibe card "homes" to see if the cursor, and therefore the card, are within their limits
    for i, v in ipairs(playSurface.cardHomes) do
        if v.type ~= "deck" then
            if self.currentMousePos.x > v.position.x and
            self.currentMousePos.x < v.position.x + v.size.x and
            self.currentMousePos.y > v.position.y and
            self.currentMousePos.y < v.position.y + v.size.y then
                isValidReleasePos = true
                releaseLocation = v
                break
            end
        end
    end

    -- Checks to see if the playSpot's P1 slots are full. No need for P2 check, as the computer will never use grabber.
    if isValidReleasePos and releaseLocation.type == "playSpot" then
        if #releaseLocation.cards[1] >= 4 then
            isValidReleasePos = false
        end
    end

    -- Checks to see if the player is dropping the card back to the correct hand, and if that hand is full.
    if isValidReleasePos and releaseLocation.type == "hand" then
        if releaseLocation.playerNum ~= self.heldObject.playerNum then
            isValidReleasePos = false
        elseif #releaseLocation.cards >= 7 then
            isValidReleasePos = false
        end
    end

    if isValidReleasePos and releaseLocation.type == "discard" then
        if releaseLocation.playerNum ~= self.heldObject.playerNum then
            isValidReleasePos = false
        end
    end

    -- also returns the valid release target (so that I can later initiate the target's addCard function from grabber)
    return isValidReleasePos, releaseLocation
end