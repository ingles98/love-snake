
function table.addToTable(set, key, opt)
    set[key] = opt or true
end

function table.removeFromTable(set, key)
    set[key] = nil
end

function table.tableContains(set, key)
    return set[key] ~= nil
end

TILESIZE = 28
GRID_W = 25
GRID_H = 16

love.math.setRandomSeed(os.time())
SnakeClass = require 'snake'
FoodClass = require 'food'
--Snake = SnakeClass:new(love.math.random(1, GRID_W), love.math.random(1, GRID_H))
zxczxc
SNAKES = {
}

function createGrid(w, h)
    GRID = {w = w, h = h}
    for i=1,w do
        GRID[i] = {}
        for j=1,h do
            GRID[i][j] = {}
        end
    end
    FoodClass:new(love.math.random(1, GRID_W), love.math.random(1, GRID_H))
end

function love.load(arg)
    -- body...
    createGrid(GRID_W,GRID_H)
end

function love.update(dt)
    --Snake:update(dt)
    for k, v in pairs(SNAKES) do
        v:update(dt)
    end
end

function love.keypressed(key, scancode, isrepeat)
    if key == "z" and not SNAKES["wasd"] then
        SNAKES["wasd"] = SnakeClass:new(love.math.random(1, GRID_W), love.math.random(1, GRID_H), "wasd")
    elseif key == "pagedown" and not SNAKES["arrows"] then
        SNAKES["arrows"] = SnakeClass:new(love.math.random(1, GRID_W), love.math.random(1, GRID_H), "arrows")
    end
end

function love.draw()
    if GRID then
        for i=1,GRID.w do
            for j=1,GRID.h do
                if GRID[i][j] == 0 then
                    love.graphics.setColor(0.1, 0.1, 0.1, 1)
                    love.graphics.rectangle("fill", i*TILESIZE, j*TILESIZE, TILESIZE, TILESIZE)
                    love.graphics.setColor(0, 1, 1, 0.3)
                    love.graphics.rectangle("line", i*TILESIZE, j*TILESIZE, TILESIZE, TILESIZE)
                elseif type(GRID[i][j]) == "table"then
                    for k,v in pairs(GRID[i][j]) do
                        if k.type == "food" then
                            k:draw()
                        end
                    end
                end
            end
        end
    end
    --Snake:draw()
    for k, v in pairs(SNAKES) do
        v:draw()
    end
    for k, v in pairs(SNAKES) do
        love.graphics.setColor(v.color)
        local x,y = love.graphics.getWidth()*0.9, 64
        if v.keyboard_arrows then y = y + 2 + love.graphics.getFont():getHeight() end
        love.graphics.print("Points: "..v.points, x, y)
    end
end
