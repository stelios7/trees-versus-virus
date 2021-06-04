Timer = require('libs/knife/timer')
Event = require('libs/knife/event')
Class = require('libs/class')
push = require('libs/push')

require 'src/utils'
require 'src/constants'

require 'src/shaders/Shaders'

require 'src/states/StateStack'
require 'src/states/BaseState'

require 'src/states/StartState'
require 'src/states/PlayState'
require 'src/states/DialogueState'
require 'src/states/InventoryState'
require 'src/states/GameOverState'
require 'src/states/FadeInState'
require 'src/states/FadeOutState'
require 'src/states/MapSizeSelectionState'

require 'src/Inventory'
require 'src/Board'
require 'src/Tile'

require 'src/gui/BaseUIElement'
require 'src/gui/Panel'
require 'src/gui/Textbox'
require 'src/gui/Label'
require 'src/gui/Icon'


gTextures = {
    ['dirt01_tile'] = love.graphics.newImage('assets/textures/tiles/dirt01_tile.png'),
    ['grass01_tile'] = love.graphics.newImage('assets/textures/tiles/grass01_tile.png'),
    ['grass02_tile'] = love.graphics.newImage('assets/textures/tiles/grass02_tile.png'),
    ['water01_tile'] = love.graphics.newImage('assets/textures/tiles/water01_tile.png'),

    ['dirt01_block'] = love.graphics.newImage('assets/textures/blocks/dirt01_block.png'),
    ['grass01_block'] = love.graphics.newImage('assets/textures/blocks/grass01_block.png'),
    ['grass02_block'] = love.graphics.newImage('assets/textures/blocks/grass02_block.png'),
    ['water01_block'] = love.graphics.newImage('assets/textures/blocks/water01_block.png'),

    ['trees'] = love.graphics.newImage('assets/textures/trees.png'),
    ['background'] = love.graphics.newImage('assets/textures/space-background.png')
}

gFrames = {
    [1] = love.graphics.newQuad(0, 0, 512, 512, gTextures.trees),
    [2] = love.graphics.newQuad(512, 0, 512, 512, gTextures.trees)
}

gFonts = {
    odibee = {
        small = love.graphics.newFont('assets/fonts/odibee.ttf', 16),
        medium = love.graphics.newFont('assets/fonts/odibee.ttf', 32),
        large = love.graphics.newFont('assets/fonts/odibee.ttf', 64)
    },
    amatic = {
        small = love.graphics.newFont('assets/fonts/amatic.ttf', 16),
        medium = love.graphics.newFont('assets/fonts/amatic.ttf', 32),
        large = love.graphics.newFont('assets/fonts/amatic.ttf', 64),
        extra_large = love.graphics.newFont('assets/fonts/amatic.ttf', 96)
    }
}

gSounds = {
    ['main'] = love.audio.newSource('assets/sounds/synth01.wav', 'static'),
    ['select'] = love.audio.newSource('assets/sounds/select.wav', 'static'),
    ['plant-tree'] = love.audio.newSource('assets/sounds/plant-tree.wav','static')
}