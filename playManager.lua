PlayManClass = {}
PlayManClass.__index = PlayManClass

function PlayManClass:new()
    local playMan = setmetatable({}, self) 

    playMan.discardedNum = 0
    playMan.manaNum = 0
    playMan.effects = {}

    return playMan
end

function PlayManClass:initiateGame()

end

function PlayManClass:playerTurn()
    
end

function PlayManClass:botTurn()

end

function PlayManClass:shuffle()

end

function PlayManClass:winCondition()

end