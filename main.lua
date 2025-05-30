-- Cassian Jones
-- Project 3 - MINOS
-- CMPM 121
-- 5/28/25

function love.load()
    -- window details
    love.window.setMode(1024, 720)
    love.window.setTitle("MINOS")
    background = love.graphics.newImage("sprites/Jungle_Arena.png")
    sizeX = love.graphics:getWidth()
    sizeY = love.graphics:getHeight()

    cardWidth = 75
    cardHeight = 105

    math.randomseed(os.time())
    playSurface = playSurfance:new()
end

function love.update()
    playSurface:update()
end

function love.draw()
    -- draw background
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(background, -sizeX/250, -sizeY/3.7, 0, 0.26, 0.26)
    -- Alignment graphics for background position below
    --[[ love.graphics.setColor(1, 0, 0)
    love.graphics.circle("fill", sizeX/2, sizeY/2, 10)
    love.graphics.line(sizeX/2, 0, sizeX/2, sizeY)
    love.graphics.line(0, sizeY/2, sizeX, sizeY/2) ]]
end