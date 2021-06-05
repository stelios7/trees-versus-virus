local timer = require "libs.knife.timer"
GameOverState = Class{__includes = BaseState}

local sin = function(x)
    return math.abs(math.sin(x))
end

function GameOverState:init(def)
    print('game over init')
    self.status = def.status
    self.score = def.score
    self.alpha = 1
end

function GameOverState:enter()

end

function GameOverState:update(dt)
    if love.keyboard.wasPressed('space') then
        gStateStack:push(FadeInState({
            r=1, g=1, b=1}, 2, function()
                while #gStateStack.states > 0 do
                    gStateStack:pop()
                end
                gStateStack:push(StartState())
            end))
    end
    self.alpha = self.alpha + dt * 2
end

function GameOverState:render()
    love.graphics.setFont(gFonts.amatic.extra_large)
    if self.status == 'loss' then
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.printf('GAME OVER', 0, 100, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(gFonts.amatic.medium)
        love.graphics.setColor(1, 0, 0, sin(self.alpha))
        love.graphics.printf('PRESS \'SPACE\' TO START AGAIN', 0, 200, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.setColor(.19, .78, .89)
        love.graphics.printf('PLANET SAVED', 0, 50, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(gFonts.amatic.large)
        love.graphics.printf('Final Score: '..self.score, 0, 150, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(gFonts.amatic.medium)
        love.graphics.setColor(1, 0, 0, sin(self.alpha))
        love.graphics.printf('PRESS \'SPACE\' TO START AGAIN', 0, 230, VIRTUAL_WIDTH, 'center')
    end
end
