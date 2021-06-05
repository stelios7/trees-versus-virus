StartState = Class{__includes = BaseState}

function StartState:init()
    gSounds['main']:play()
    gSounds['main']:setLooping(true)

    -- gStateStack:push(GameOverState({status = 'win', score = 500}))
    
    gStateStack:push(FadeInState({
        r=0, g=0, b=0}, 1, function()
            while #gStateStack.states > 0 do
                gStateStack:pop()
            end
            gStateStack:push(MapSizeSelectionState())
        end))

end

function StartState:enter()
    gStateStack:pop()
end