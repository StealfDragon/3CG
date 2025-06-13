-- Cassian Jones
-- Project 3 - MINOS
-- CMPM 121
-- 5/28/25

require "playSurface"

function love.load()
    -- Window details
    love.window.setMode(1024, 720)
    love.window.setTitle("MINOS")
    background = love.graphics.newImage("assets/Jungle_Arena.png")
    sizeX = love.graphics:getWidth()
    sizeY = love.graphics:getHeight()

    defaultFont = love.graphics.getFont()
    bigFont = love.graphics.newFont("assets/Greek-Freak.ttf", 16)
    love.graphics.setFont(bigFont)

    cardWidth = 75.0
    cardHeight = 105.0

    math.randomseed(os.time())
    grabber = GrabberClass:new()
    playMan = PlayManClass:new()
    playSurface = PlaySurfaceClass:new() -- Keeping main really clean this time, so all layout stuff is handled by PlaySurface
    playMan:initiateGame()
    playMan:subscribe(playSurface)
end

function love.update(dt)
    if playSurface and playMan then
        playSurface:update()
        playMan:update(dt)
    end
end

function love.draw()
    -- draw background
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(background, -sizeX/250, -sizeY/3.7, 0, 0.26, 0.26)
    playSurface:draw()
end