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

    self.UI_items={[1]=Panel{x=VIRTUAL_WIDTH-205,y=5,width=200,height=60,background={r=.25,g=.25,b=.25}},[2]=Icon{x=VIRTUAL_WIDTH-205+5,y=5+5,texture=gTextures['trees'],frame=gFrames[1],shader=love.graphics.newShader(SHADERS.rainbow_pixel),scaleX=50/512,scaleY=50/512},[3]=Icon{x=VIRTUAL_WIDTH-205+100+5,y=5+5+5+2,texture=gTextures['dirt01_block'],shader=love.graphics.newShader(SHADERS.infection),scaleX=5/20,scaleY=5/20}}

    self.virus = {
        virusTimer = 0,
        virusSpreadFactor = 0,
        virusSpawnThreshold = 2.5,
        infectionrate = 0
    }

    self.inventory = {}
end

function PlayState:update(dt)
    self.MouseMovement()

    self.board:update(dt)
    self.board.cursor.offset.x = translateOffsetX
    self.board.cursor.offset.y = translateOffsetY

    if not self.board:checkAvailable() then
        gStateStack:pop()
        gStateStack:push(FadeOutState({r=0,g=0,b=0}, 0.5, function()
            gStateStack:push(GameOverState())
        end))
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
    love.graphics.setFont(gFonts.amatic.medium)
    love.graphics.printf(self.board.treesPlanted, VIRTUAL_WIDTH - 205 + 45, 18, 50, 'left')
    love.graphics.printf(#self.board.infectedTiles, VIRTUAL_WIDTH - 205 + 145, 18, 50, 'left')
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