local timer = require "libs.knife.timer"
PlayState = Class{__includes = BaseState}

local mouseStartX, mouseStartY
local translateOffsetX = 0
local translateOffsetY = 0
local shaders = {}
local atan = function(x)
    return math.atan(math.rad(x))
end

function PlayState:init(board)
    self.board = board
    
    self.highlightedTiles = {}
    self.mousedown = false
    
    self.dialogueOpened = false
    self.inventoryOpened = false
    
    local pWidth = VIRTUAL_WIDTH - 205
    self.UI_items={
        [1]=Panel{x=pWidth,y=0,width=205,height=60,background={r=.15,g=.15,b=.15}},
        [2]=Icon{x=pWidth,y=6,texture=gTextures['trees'],frame=gFrames[1],shader=love.graphics.newShader(SHADERS.rainbow_pixel),scaleX=50/512,scaleY=50/512},
        [3]=Icon{x=pWidth+125,y=15,texture=gTextures['dirt01_block'],shader=love.graphics.newShader(SHADERS.infection),scaleX=25/128,scaleY=25/128}
    }
    
    self.background={
        texture=gTextures['background'],
        position={x=0,y=0,scaleX=.8,scaleY=.8},
        scroll=0,
        scrollspeed=10,
        scroll_loop_point=500
    }

    self.virus={virusTimer=0,virusSpreadFactor=0,virusSpawnThreshold=2.5,infectionrate=0}
    self.seeds = {
        current_amount = 10,
        use_seed = function()self.seeds.current_amount = self.seeds.current_amount - 1 end
    }

    -- Timer.every(1, function()
    --     self.seeds.current_amount = self.seeds.current_amount + self.board.treesPlanted
    -- end)

    self.inventory = {}
end

function PlayState:update(dt)
    self.MouseMovement()

    self:backgroundMovement(dt)

    self.seeds.current_amount = self.seeds.current_amount + atan(self.board.treesPlanted * dt * POINTS_MULTIPLIER)

    self.board:update(dt)
    self.board.cursor.offset.x = translateOffsetX
    self.board.cursor.offset.y = translateOffsetY

    self:GameOver()
    
    -- if self:GameOver() then
    --     gStateStack:pop()
    --     gStateStack:push(FadeOutState({r=0,g=0,b=0}, 0.5, function()
    --         gStateStack:push(GameOverState())
    --     end))
    -- end

    if love.mouse.wasReleased(1) then
        self.mousedown = false
    end

    if love.mouse.wasPressed(1) then
        self.mousedown = true

        if not self.board.cursor.overboard then
            for y = 1, #self.board.tiles do
                for x =1, #self.board.tiles[y] do
                    self.board.tiles[y][x].highlighted = false
                end
            end
        end
    end

    if self.board:isCursorOverBoard() then
        local _tile = self.board.tiles[self.board.cursor.maplocation.y][self.board.cursor.maplocation.x]

        if not _tile.highlighted then
            self.board:highlightTile(_tile)
        end

        if self.mousedown and not _tile.hasTree and string.find(_tile.id, 'grass') and math.floor(self.seeds.current_amount) > 0 then
            self.board.treesPlanted = self.board.treesPlanted + _tile:plantTree()
            self.seeds.use_seed()
        end
    end

    self.virus.virusTimer = self.virus.virusTimer + dt
    if self.virus.virusTimer >= self.virus.virusSpawnThreshold then
        self.virus.virusTimer = 0
        if not self.virus.started then
            self.virus.started = true
            local tile = self.board.tiles[BOARD_HEIGHT][BOARD_WIDTH]
            tile.infected = true
            tile.canInfect = true
            self.board.infectedTiles[1] = tile
        else
            for i = #self.board.infectedTiles, 1, -1 do
                -- Infect adjacent tiles
                local tile = self.board.infectedTiles[i]
                if tile.canInfect then
                    self.board:contaminate(tile)
                end
            end
        end
    end

    self.UI_items[2]:update(dt)
    
    diagnosticsList[3] = 'Grid Location: '..self.board.cursor.maplocation.x..','..self.board.cursor.maplocation.y
end

function PlayState:render()
    love.graphics.push()
    self:renderBackground()
    love.graphics.translate(translateOffsetX or 0, translateOffsetY or 0)
    self.board:render()
    love.graphics.pop()

    for i = 1, #self.UI_items do
        self.UI_items[i]:render()
    end
    love.graphics.setFont(gFonts.amatic.medium)
    local h = 8
    love.graphics.printf(self.board.treesPlanted, self.UI_items[2].x + 35, h, 50, 'left')
    love.graphics.printf(string.format('%.1f', math.min(99, self.seeds.current_amount)), self.UI_items[2].x + 65, h, 55, 'center')
    love.graphics.printf(#self.board.infectedTiles, self.UI_items[3].x + 35, h, 50, 'left')
end

function PlayState.MouseMovement()

    -- ΚΑΘΕ ΦΟΡΑ ΠΟΥ ΠΑΤΑΩ ΤΗ ΡΟΔΕΛΑ, ΑΠΟΘΗΕΚΥΩ ΤΗΝ ΑΡΧΙΚΗ ΤΟΠΟΘΕΣΙΑ ΤΟΥ ΠΟΝΤΙΚΙΟΥ ΩΣΤΕ ΝΑ ΜΠΟΡΩ ΝΑ ΒΡΙΣΚΩ
    -- ΤΗΝ ΔΙΑΦΟΡΑ ΓΙΑ ΟΣΗ ΩΡΑ ΤΗΝ ΕΧΩ ΚΡΑΤΗΜΕΝΗ
    if love.mouse.wasPressed(3) then
        mouseStartX = GetMouseX() - (translateOffsetX or 0)
        mouseStartY = GetMouseY() - (translateOffsetY or 0)
    end

    if love.mouse.isDown(3) then
        translateOffsetX = GetMouseX() - mouseStartX
        translateOffsetY = GetMouseY() - mouseStartY
    end
end

function PlayState:isVirusInfectious()
    for i = 1, #self.board.infectedTiles do
        if self.board.infectedTiles[i].canInfect then
            return true
        end
    end
    return false
end

function PlayState:renderBackground()
    love.graphics.setColor(.8, .8, .8, .8)
    love.graphics.draw(self.background.texture, self.background.position.x, self.background.position.y,
        0, self.background.position.scaleX, self.background.position.scaleY)
end

function PlayState:backgroundMovement(dt)
    local a = 2 * math.atan((love.mouse:getX() - WINDOW_WIDTH / 2) / WINDOW_WIDTH)
    local b = 2 * math.atan((love.mouse:getY() - WINDOW_HEIGHT / 2) / WINDOW_HEIGHT)

    self.background.scroll = (self.background.scroll + self.background.scrollspeed * dt * 0.5)

    self.background.position.x = - math.abs(math.sin(math.rad(self.background.scroll))) * 75
    self.background.position.y = b * 10
end

function PlayState:GameOver()
    -- If there are infected tiles that can still spread the virus, return false
    for k, tile in pairs(self.board.infectedTiles) do
        if tile.canInfect then
            return
        end
    end

    -- If infection has stopped then let user finish planting the trees
    for y = 1, BOARD_HEIGHT do
        for x = 1, BOARD_WIDTH do
            local tile = self.board.tiles[y][x]
            if string.find(tile.id, 'grass') and not tile.hasTree and not tile.infected then
                return
            end
        end
    end

    -- If there are more infected tiles than trees game is over
    local total_tiles = BOARD_WIDTH * BOARD_HEIGHT
    if #self.board.infectedTiles > total_tiles * .5 then
        gStateStack:pop()
        gStateStack:push(FadeInState({r=1, g=1, b=1}, 1, function()
            gStateStack:push(GameOverState({status = 'loss'}))
        end))
        return
    end

    -- If there are no more tiles to be planted on then calculate final score
    local final_score = 0
    for y = 1, BOARD_HEIGHT do
        for x = 1, BOARD_WIDTH do
            local tile = self.board.tiles[y][x]
            if string.find(tile.id, 'water') and not tile.infected then
                final_score = final_score + 3
            elseif not tile.infected then
                final_score = final_score + 2
            end
        end
    end

    final_score = final_score - 2 * #self.board.infectedTiles

    gStateStack:pop()
    gStateStack:push(FadeInState({r=1,g=1,b=1}, 1, function()
        gSounds['main']:stop()
        gStateStack:push(GameOverState({status = 'win', score = final_score}))
    end))

end