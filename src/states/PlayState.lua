PlayState = Class{__includes = BaseState}

local mouseStartX, mouseStartY
local translateOffsetX = 0
local translateOffsetY = 0
local shaders = {}

function PlayState:init(board)
    self.board = board
    
    self.highlightedTiles = {}
    
    self.dialogueOpened = false
    self.inventoryOpened = false

    self.UI_items={[1]=Panel{x=VIRTUAL_WIDTH-205,y=5,width=200,height=60,background={r=.1,g=.1,b=.1}},[2]=Icon{x=VIRTUAL_WIDTH-205+5,y=5+5,texture=gTextures['trees'],frame=gFrames[1],shader=love.graphics.newShader(SHADERS.rainbow_pixel),scaleX=50/512,scaleY=50/512},[3]=Icon{x=VIRTUAL_WIDTH-205+100+5,y=5+5+5+2,texture=gTextures['dirt01_block'],shader=love.graphics.newShader(SHADERS.infection),scaleX=5/20,scaleY=5/20}}

    self.virus = {
        virusTimer = 0,
        virusSpreadFactor = 0,
        virusSpawnThreshold = 5,
        infectionrate = 0
    }

    self.inventory = {}
end

function PlayState:update(dt)
    self.MouseMovement()

    self.board:update(dt)
    self.board.cursor.offset.x = translateOffsetX
    self.board.cursor.offset.y = translateOffsetY

    self.virus.virusTimer = self.virus.virusTimer + dt
    if self.virus.virusTimer >= self.virus.virusSpawnThreshold then
        self.virus.virusTimer = 0

        if not self.virus.started then
            self.virus.started = true
            local tile = self.board.tiles[BOARD_HEIGHT][BOARD_WIDTH]
            tile.infected = true
            self.board.infectedTiles[1] = tile
        else
            for i = #self.board.infectedTiles, 1, -1 do
                -- Infect adjacent tiles
                local tile = self.board.infectedTiles[i]
                
                local t = self.board.tiles[math.min(BOARD_HEIGHT, tile.gridY + 1)][math.min(BOARD_WIDTH, tile.gridX + 1)]
                if not t.infected and not t.planted then
                    t.infected = true
                    table.insert(self.board.infectedTiles, t)
                end

                t = self.board.tiles[math.min(BOARD_HEIGHT, tile.gridY + 1)][math.max(1, tile.gridX - 1)]
                if not t.infected and not t.planted then
                    t.infected = true
                    table.insert(self.board.infectedTiles, t)
                end

                t = self.board.tiles[math.max(1, tile.gridY - 1)][math.min(BOARD_WIDTH, tile.gridX + 1)]
                if not t.infected and not t.planted then
                    t.infected = gTextures
                    table.insert(self.board.infectedTiles, t)
                end

                t = self.board.tiles[math.max(1, tile.gridY - 1)][math.max(1, tile.gridX - 1)]
                if not t.infected and not t.planted then
                    t.infected = true
                    table.insert(self.board.infectedTiles, t)
                end

            end

            if self:noMoreCleanTiles() then
                print('Game Over')
                gStateStack:pop()
                gStateStack:push(FadeInState({r = 1, g = 1, b = 1}, 1, function()
                    gStateStack:push(GameOverState())
                    gStateStack:push(FadeOutState({
                        r = 1, g = 1, b =1,
                    }, 1, function()
                        
                    end))
                end))
            end
        end

        print('Virus spread')

    end

    if love.keyboard.wasPressed('tab') or love.keyboard.wasPressed('i') then
        -- gStateStack:push(InventoryState())
    end

    diagnosticsList[3] = 'Grid Location: '..self.board.cursor.maplocation.x..','..self.board.cursor.maplocation.y

    self.UI_items[2]:update(dt)
end

function PlayState:render()
    love.graphics.push()
    love.graphics.translate(translateOffsetX or 0, translateOffsetY or 0)
    self.board:render()
    love.graphics.pop()

    for i = 1, #self.UI_items do
        self.UI_items[i]:render()
    end
    love.graphics.setFont(gFonts.odibee.medium)
    love.graphics.printf(self.board.treesPlanted, VIRTUAL_WIDTH - 205 + 45, 18, 50, 'left')
    love.graphics.printf(#self.board.infectedTiles, VIRTUAL_WIDTH - 205 + 145, 18, 50, 'left')
end

function PlayState.MouseMovement()
    if love.mouse.wasPressed(3) then
        mouseStartX = love.mouse:getX() - (translateOffsetX or 0)
        mouseStartY = love.mouse:getY() - (translateOffsetY or 0)
    end

    if love.mouse.isDown(3) then
        translateOffsetX = love.mouse:getX() - mouseStartX
        translateOffsetY = love.mouse:getY() - mouseStartY
    end
end

function PlayState:noMoreCleanTiles()
    for i = 1, #self.board.tiles do
        for j = 1, #self.board.tiles[i] do
            if not self.board.tiles[i][j].infected and not self.board.tiles[i][j].planted then
                return false
            end
        end
    end
    return true
end