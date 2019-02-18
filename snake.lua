local snake = {
    size = TILESIZE*0.6,
    length = 3,
    speed = 4,
    last_move = 0,
    x = 0,
    y = 0,
    last_x = 0,
    last_y = 0,
    dir_x = 0,
    dir_y = 0,
    last_dir_x = 0,
    last_dir_y = 0,
    parts = {},
    points = 0,
    played = false,
    keyboard_arrows = false,
    keyboard_wasd = false,
    color = {0.2, 1, 0.3, 1},
    type = "snake",
}

snake.update = function (this,dt)
    if this.dead then return end
    this:input()
    this:move(dt)

end

snake.move = function (this,dt)
    local time = (this.last_move + 1/this.speed) - love.timer.getTime()
    this.rel_x = ((this.x + this.dir_x) - this.x)*time*TILESIZE
    this.rel_y = ((this.y + this.dir_y) - this.y)*time*TILESIZE

    if love.timer.getTime() < this.last_move + 1/this.speed or (this.dir_x == 0 and this.dir_y == 0) then return end
    this.last_move = love.timer.getTime()
    this.last_x = this.x
    this.last_y = this.y
    this.x = this.x + this.dir_x
    this.y = this.y + this.dir_y
    --GRID[this.last_x][this.last_y] = 0
    --GRID[this.x][this.y] = this

    if GRID[this.x] and GRID[this.x][this.y] and type(GRID[this.x][this.y]) == "table" then
        --GRID[this.x][this.y]:onEat(this)
        for k,v in pairs(GRID[this.x][this.y]) do
            if k.type == "food" then
                k:onEat(this)
            elseif k.type == "snake" and k ~= this then
                this:die()
            end
        end
    end

    this:checkBoundaries()
    table.addToTable(GRID[this.x][this.y], this)
    table.removeFromTable(GRID[this.last_x][this.last_y], this)

    this:checkParts()
    this.inputted = false

    if not this.played then
        this.played = true
    end
end

snake.checkBoundaries = function(this)
    if this.x > GRID_W then this.x = 1
    elseif this.x < 1 then this.x = GRID_W end
    if this.y > GRID_H then this.y = 1
    elseif this.y < 1 then this.y = GRID_H end
end

snake.checkParts = function (this)
    for i = 1, this.length-1 do
        if this.dead then return end

        if not this.parts[i] then
            this.parts[i] = {x = (this.parts[i-1] or this).x, y = (this.parts[i-1] or this).y, size = this.size*0.8}
        end
        this.parts[i].last_x = this.parts[i].x
        this.parts[i].last_y = this.parts[i].y

        if i == 1 then
            this.parts[i].x = this.last_x
            this.parts[i].y = this.last_y
            this.parts[i].rel_x = (this.x - this.parts[i].x)*0.5
            this.parts[i].rel_y = (this.y - this.parts[i].y)*0.5
        else
            this.parts[i].x = this.parts[i-1].last_x
            this.parts[i].y = this.parts[i-1].last_y
            this.parts[i].rel_x = (this.parts[i-1].x - this.parts[i].x)*0.5
            this.parts[i].rel_y = (this.parts[i-1].y - this.parts[i].y)*0.5
        end

        table.addToTable(GRID[this.parts[i].x][this.parts[i].y], this)
        table.removeFromTable(GRID[this.parts[i].last_x][this.parts[i].last_y], this)

        --[[if this.x == this.parts[i].x and this.y == this.parts[i].y and this.played then
            this:die()
        end]]
    end
end

snake.die = function(this)
    this.dead = true

    --GRID[this.x][this.y] = 0
    table.removeFromTable(GRID[this.x][this.y], this)

    for k,v in pairs(this.parts) do
        --GRID[v.x][v.y] = 0
        table.removeFromTable(GRID[v.x][v.y], this)
    end

    if this.keyboard_wasd then
        SNAKES["wasd"] = SnakeClass:new(love.math.random(1, GRID_W), love.math.random(1, GRID_H), "wasd")
    elseif this.keyboard_arrows then
        SNAKES["arrows"] = SnakeClass:new(love.math.random(1, GRID_W), love.math.random(1, GRID_H), "arrows")
    end
end

snake.input = function (this)
    if this.inputted then return end

    if this.keyboard_arrows then
        if love.keyboard.isDown("left") and this.dir_x ~= 1 then
            this.dir_x = -1
            this.dir_y = 0
            this.inputted = true
        elseif love.keyboard.isDown("right") and this.dir_x ~= -1 then
            this.dir_x = 1
            this.dir_y = 0
            this.inputted = true
        elseif love.keyboard.isDown("up") and this.dir_y ~= 1 then
            this.dir_y = -1
            this.dir_x = 0
            this.inputted = true
        elseif love.keyboard.isDown("down") and this.dir_y ~= -1 then
            this.dir_y = 1
            this.dir_x = 0
            this.inputted = true
        end
    elseif this.keyboard_wasd then
        if love.keyboard.isDown("a") and this.dir_x ~= 1 then
            this.dir_x = -1
            this.dir_y = 0
            this.inputted = true
        elseif love.keyboard.isDown("d") and this.dir_x ~= -1 then
            this.dir_x = 1
            this.dir_y = 0
            this.inputted = true
        elseif love.keyboard.isDown("w") and this.dir_y ~= 1 then
            this.dir_y = -1
            this.dir_x = 0
            this.inputted = true
        elseif love.keyboard.isDown("s") and this.dir_y ~= -1 then
            this.dir_y = 1
            this.dir_x = 0
            this.inputted = true
        end
    end
end

snake.new = function (this, x, y, keys)
    local o = {x = x, y = y, color = {}, parts = {}}
    setmetatable(o, this)
    this.__index = this
    o.color.__index = o.color
    o.__index = this

    if keys == "wasd" then
        o.keyboard_wasd = true
        o.color = {0.2, 1, 0.3, 1}
    elseif keys == "arrows" then
        o.keyboard_arrows = true
        o.color = {1, 0.4, 0.3, 1}
    end

    return o
end

snake.draw = function (this)
    love.graphics.setColor(this.color)
    love.graphics.rectangle("fill", this.x*TILESIZE + TILESIZE/2 - this.size/2 + (this.rel_x or 0), this.y*TILESIZE + TILESIZE/2 - this.size/2 + (this.rel_y or 0),this.size, this.size)

    for k,v in ipairs(this.parts) do
        if v.x and v.y then
            love.graphics.rectangle("fill", v.x*TILESIZE + TILESIZE/2 - v.size/2 + (v.rel_x or 0), v.y*TILESIZE + TILESIZE/2 - v.size/2 + (v.rel_y or 0),v.size, v.size)
        end
    end
end


return snake
