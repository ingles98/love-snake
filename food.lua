local fd = {
    type = "food",
    x = 0,
    y = 0,
    size = TILESIZE*0.5,
    points = 3,
}

fd.new = function (this, x, y)
    local o = {x = x, y = y}
    setmetatable(o, this)
    this.__index = this
    o.__index = this

    table.addToTable(GRID[x][y], o)
    return o
end

fd.draw = function(this)
    love.graphics.setColor(1, 0.3, 0.3, 1)
    love.graphics.circle("fill", this.x*TILESIZE + (TILESIZE/2), this.y*TILESIZE + (TILESIZE/2) , this.size/2)
end

fd.onEat = function (this, obj)
    obj.length = obj.length +1
    obj.points = obj.points + this.points
    table.removeFromTable(GRID[this.x][this.y], this)
    FoodClass:new(love.math.random(1, GRID_W), love.math.random(1, GRID_H))
end


return fd
