MapSizeSelectionState = Class{__includes = BaseState}

local a = 'Choose Map Size'

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
        gStateStack:pop()
        gStateStack:push(PlayState(Board()))
        gStateStack:push(DialogueState('Welcome to this new World.\nPress \'ENTER\' or \'SPACE\' to continue...'))
    elseif love.keyboard.wasPressed('left') then
        self.selection = math.max(1, self.selection -1)
    elseif love.keyboard.wasPressed('right') then
        self.selection = math.min(3, self.selection + 1)
    end
end

function MapSizeSelectionState:render()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts.odibee.large)
    love.graphics.printf(a, VIRTUAL_WIDTH / 2 - 250, 150, 500, 'center')
    local a = '<  '..self.sizes[self.selection]..'  >'
    love.graphics.printf(a, VIRTUAL_WIDTH / 2 - 150, VIRTUAL_HEIGHT / 2, 300, 'center')
    local a = '(enter)'
end