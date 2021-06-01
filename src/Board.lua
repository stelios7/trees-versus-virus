Board = Class{}

--#region LOCAL DECLARATIONS

ZOOM_SCALE = 1
local _dt = 0
local TILE, BLOCK = 'tile', 'block'
local shaders = {}
local TileGrass01, TileGrass02, TileDirt01, TileWater01 = 'grass01_tile', 'grass02_tile', 'dirt01_tile', 'water01_tile'
local BlockGrass01, BlockGrass02, BlockDirt01, BlockWater01 = 'grass01_block', 'grass02_block', 'dirt01_block', 'water01_block'
local randomTile = function(x, y, type)
    local rand = math.random(BOARD_WIDTH)
    if type == TILE then
        return rand > x - 1 and TileGrass01 or (rand > BOARD_WIDTH / 2 and rand < BOARD_WIDTH - 1) and TileDirt01 or TileWater01
    elseif type == BLOCK then
        return rand > x - 1 and BlockGrass01 or (rand > BOARD_WIDTH / 2 and rand < BOARD_WIDTH - 1) and BlockDirt01 or BlockWater01
    end
end

--#endregion

function Board:init(w, h)
    self.tiles = {}
    self:generateTiles(w or BOARD_WIDTH, h or BOARD_HEIGHT)

    self.cursor = {
        ['screenlocation'] = {
            x = love.mouse:getX(),
            y = love.mouse:getY()
        },
        ['maplocation'] = ScreenToMapCoords(),
        ['overboard'] = false,
        ['offset'] = {
            ['x'] = 0,
            ['y'] = 0
        }
    }

    self.infectedTiles = {}
    self.treesPlanted = 0

    -- Wanted to make EVENT based system for highlighting but changed my mind
    -- Event.on('tile-get-focus',function(a,b)for c=1,#self.tiles do for d=1,#self.tiles[c]do if not a==d and not b==c then self.tiles[c][d].highlighted=false else self.tiles[c][d].highlighted=true end end end end)

    self.shaders = {}
    self.shaders.rainbow = love.graphics.newShader(SHADERS.rainbow_pixel)
    self.shaders.infection = love.graphics.newShader(SHADERS.infection)
    self.zoom = ZOOM_SCALE
end

function Board:update(dt)
    _dt = _dt + dt
    self.zoom = ZOOM_SCALE
    
    self.cursor.maplocation = ScreenToMapCoords(self.zoom, self.cursor.offset.x, self.cursor.offset.y)

    if self:isCursorOverBoard() and not self.cursor.overboard then
        self.cursor.overboard = true
    elseif self.cursor.overboard and not self:isCursorOverBoard() then
        self.cursor.overboard = false
    end

    if self:isCursorOverBoard() then
        local _tile = self.tiles[self.cursor.maplocation.y][self.cursor.maplocation.x]
        if love.mouse.wasPressed(1) then
            -- plant tree
            if string.find(_tile.id, 'grass') then
                _tile:plantTree()
                self.treesPlanted = self.treesPlanted + 1
            end
        end
        
        if not _tile.highlighted then
            self:highlightTile(_tile)
        end
    else
        for y = 1, #self.tiles do
            for x =1, #self.tiles[y] do
                self.tiles[y][x].highlighted = false
            end
        end
    end

    for y = 1, #self.tiles do
        for x = 1, #self.tiles[y] do
            self.tiles[y][x]:update(dt)
        end
    end
end

function Board:render()
    love.graphics.scale(self.zoom, self.zoom)

    love.graphics.setShader()
    for k, row in pairs(self.tiles) do
        for v, tile in pairs(row) do
            love.graphics.setShader()
            if tile.infected then
                love.graphics.setShader(self.shaders.infection)
                self.shaders.infection:send('u_time', _dt)
            elseif tile.highlighted or tile.selected then
                love.graphics.setShader(self.shaders.rainbow)
                self.shaders.rainbow:send('u_time', _dt)
            end
            tile:render()
        end
    end
end

function Board:generateTiles(cols, rows)
    for y = 1, rows do
        self.tiles[y] = {}
        for x = 1, cols do
            local coords = MapToScreenCoords(x-1, y-1)
            local tile = Tile{id=randomTile(x,y,'tile'),screenX=coords.x,screenY=coords.y,gridX=x,gridY=y}
            self.tiles[y][x] = tile
        end
    end
end

function Board:isCursorOverBoard(offsetX, offsetY)
    return (self.cursor.maplocation.x > 0 and self.cursor.maplocation.x <= BOARD_WIDTH) and (self.cursor.maplocation.y > 0 and self.cursor.maplocation.y <= BOARD_HEIGHT)
end

function Board:highlightTile(tile)
    local tx, ty = tile.gridX, tile.gridY
    for y = 1, #self.tiles do
        for x =1, #self.tiles[y] do
            if x == tx and y == ty then
                self.tiles[y][x].highlighted = true
            else
                self.tiles[y][x].highlighted = false
            end
        end
    end
end

function love.wheelmoved(x, y)
    ZOOM_SCALE = math.max(MAX_ZOOMOUT, math.min((ZOOM_SCALE + y * .1), MAX_ZOOMIN))
end