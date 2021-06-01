GameOverState = Class{__includes = BaseState}

function GameOverState:init()
    print('game over init')
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
end

function GameOverState:render()
    love.graphics.reset()
    love.graphics.origin()
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.setFont(gFonts.odibee.large)
    love.graphics.printf('GAME OVER', 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts.odibee.medium)
    love.graphics.printf('PRESS \'SPACE\' TO START AGAIN', 0, 200, VIRTUAL_WIDTH, 'center')
end
