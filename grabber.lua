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
        self.heldObject.position = self.currentMousePos - self.highlightOffset--self.heldObject.position = self.currentMousePos - Vector(cardWidth / 2, cardHeight / 2)
    end
end

function GrabberClass:grab(card)
    self.grabPos = self.currentMousePos
    self.highlightOffset = self.currentMousePos - card.position
    print("GRAB - " .. tostring(self.grabPos))

    if self.heldObject == nil then
        self.heldObject = card
        self.heldObject.state = CARD_STATE.GRABBED
    end
end

function GrabberClass:release()
    print("RELEASE - ")
    -- NEW: some more logic stubs here
    if self.heldObject == nil then -- we have nothing to release
        return
    end

    -- TODO: eventually check if release position is invalid and if it is
    -- return the heldObject to the grabPosition
    local isValidReleasePosition = true -- *insert actual check instead of "true"*
    if not isValidReleasePosition then
        self.heldObject.position = self.grabPos
    end

    self.heldObject.state = 0 -- it's no longer grabbed

    self.heldObject = nil
    self.grabPos = nil
    self.highlightOffset = nil
end