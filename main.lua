require 'src/dependencies'

diagnosticsList = {}

function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Isometric Tiles')
    table.insert(diagnosticsList, string.format('FPS: %.2f',love.timer.getFPS()))
    table.insert(diagnosticsList, 'Cursor Location: '..love.mouse:getX()..','..love.mouse:getY())    

    love.window.setMode(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, {vsync = false})
    push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT,{vsync=false,fullscreen=false,resizable=false,canvas=true})

    love.keyboard.keysPressed = {}
    love.mouse.keyPressed = {}
    love.mouse.keyReleased = {}

    gSounds['select']:setVolume(0.2)
    
    _G.gStateStack = StateStack()
    gStateStack:push(StartState())
    
    diagnosticsEnabled = false
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'f1' then
        diagnosticsEnabled = not diagnosticsEnabled
    end

    love.keyboard.keysPressed[key] = true
end

function love.mouse.wasReleased(key)
    return love.mouse.keysReleased[key]
end

function love.mouse.wasPressed(key)
    return love.mouse.keysPressed[key]
end

function love.mousepressed(x, y, key)
    love.mouse.keysPressed[key] = true
end

function love.mousereleased(x, y, key)
    love.mouse.keysReleased[key] = true
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    Timer.update(dt)
    
    gStateStack:update(dt)
    
    love.keyboard.keysPressed = {}
    love.mouse.keysPressed = {}
    love.mouse.keysReleased = {}
    
    diagnosticsList[1] = string.format('FPS: %.2f',1/love.timer.getDelta())
    diagnosticsList[2] = 'Cursor Location: '..love.mouse:getX()..','..love.mouse:getY()
end

function love.draw()
    push:start()

    gStateStack:render()
    
    push:finish()

    if diagnosticsEnabled then
        Diagnostics()
    end
end

function Diagnostics()
    love.graphics.setFont(gFonts.amatic.small)
    for i = 1, #diagnosticsList do
        if diagnosticsList[i] then
            love.graphics.print(diagnosticsList[i], 5, 5 + 25 * (i - 1))
        end
    end
end