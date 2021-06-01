Tile = Class{}

function Tile:init(def)
    self.screenX = def.screenX
    self.screenY = def.screenY

    self.width = TILE_WIDTH
    self.height = TILE_HEIGHT

    self.scale = {x = 1, y = 1}

    self.gridX = def.gridX
    self.gridY = def.gridY
    
    self.id = def.id
end

function Tile:update(dt)
    if self.infected and self.planted then
        self.planted = false
    end
end

function Tile:render()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gTextures[self.id], self.screenX, self.screenY, 0, self.scale.x, self.scale.y)
    if self.planted then
        love.graphics.draw(gTextures['trees'], gFrames[1], self.screenX, self.screenY - 64, 0, 0.3, 0.3)
    end
end

function Tile:plantTree()
    self.planted = true
end