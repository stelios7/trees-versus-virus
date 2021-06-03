InventoryState = Class{__includes = BaseState}

local panelWidth = 450
local panelHeight = VIRTUAL_HEIGHT - 128

function InventoryState:init(inventory, callback)
    local a=Panel{x=-panelWidth,y=64,width=panelWidth,height=panelHeight,background={r=36/255,g=46/255,b=46/255}}

    -- CHARACTER NAME LABEL
    a:addChild(Label{x=panelWidth/5,y=5,width=3*panelWidth/5,height=32,msg={text='STATISTICS',font=gFonts.amatic.medium, alignment = 'center'},linked=true,parent=a})

    -- CHARACTER ATTRIBUTE LABELS
    a:addChild(self:newLabel(5, 85, a, 'TOTAL TILES:'))
    a:addChild(self:newLabel(5, 85+35, a, 'SAFE TILES:'))
    a:addChild(self:newLabel(5, 85+70, a, 'INFECTED:'))
    a:addChild(self:newLabel(5, 85+105, a, 'REMAINING:'))
    -- a:addChild(Label{x=10,y=50+105,width=2*panelWidth/5,height=35,msg={text='REMAINING:',font=gFonts.amatic.medium,alignment='right'},parent=a})
    -- a:addChild(Label{x=10,y=50+140,width=2*panelWidth/5,height=35,msg={text='LUCK:',font=gFonts.amatic.medium,alignment='right'},parent=a})

    self.invPanel=Panel{parent=a,x=5,y=3*panelHeight/5,width=panelWidth-10,height=2*panelHeight/5-5,background={r=18/255,g=28/255,b=28/255},linked=true}
    a:addChild(self.invPanel)
    
    self.callback = callback or function() end
    self.inventory = {panel = a}

    self.tween = Timer.tween(0.15, { [self.inventory.panel] = {x = 0} })
    self.open = true
end

function InventoryState:update(dt)
    self.inventory.panel:update(dt)
    if love.keyboard.wasPressed('tab') then
        if self.open then self.tween:remove()self.open=false;self.tween=Timer.tween(0.15,{[self.inventory.panel]={x=-panelWidth}}):finish(function()gStateStack:pop()end)else self.tween:remove()self.open=true;self.tween=Timer.tween(0.15,{[self.inventory.panel]={x=0}})end
    end
end


function InventoryState:render()
    love.graphics.push()
    love.graphics.origin()
    love.graphics.setShader()
    self.inventory.panel:render()
    love.graphics.pop()
end

function InventoryState:newLabel(x, y, parent, text)
    return Label{x=x,y=y,width=3*panelWidth/5,height=35,msg={text=text,font=gFonts.amatic.medium,alignment='right'},parent=parent}
end