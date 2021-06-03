MapSizeSelectionState = Class{__includes = BaseState}


function MapSizeSelectionState:init()
    self.sizes = {[1] = 'small', [2] = 'medium', [3] = 'large'}
    self.defaultSize = 'medium'
    self.selection = 2
end

function MapSizeSelectionState:update(dt)
    if love.keyboard.wasPressed('return') then
        if self.selection == 1 then
            BOARD_WIDTH, BOARD_HEIGHT = 10, 10
        elseif self.selection == 2 then
            BOARD_WIDTH, BOARD_HEIGHT = 20, 20
        else
            BOARD_WIDTH, BOARD_HEIGHT = 30, 30
        end
        gSounds['select']:stop()
        gSounds['select']:play()        
        gStateStack:pop()
        gStateStack:push(FadeInState({r=0.3,g=0.3,b=0.3},2,function()
            gStateStack:push(FadeOutState({r=0.3,g=0.3,b=0.3},1, function()
                gStateStack:push(PlayState(Board()))
            end)) end))

    elseif love.keyboard.wasPressed('left') then
        self.selection = math.max(1, self.selection -1)
        gSounds['select']:stop()
        gSounds['select']:play()
    elseif love.keyboard.wasPressed('right') then
        self.selection = math.min(3, self.selection + 1)
        gSounds['select']:stop()
        gSounds['select']:play()
    end
end

function MapSizeSelectionState:render()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts.amatic.large)
    local a = 'Choose Map Size'
    love.graphics.printf(a, VIRTUAL_WIDTH / 2 - 200, VIRTUAL_HEIGHT / 6, 400, 'center')
    a = '<  '..self.sizes[self.selection]..'  >'
    love.graphics.printf(a, VIRTUAL_WIDTH / 2 - 150, 2 * VIRTUAL_HEIGHT / 3, 300, 'center')
end