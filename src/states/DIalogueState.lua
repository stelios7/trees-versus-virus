DialogueState = Class{__includes = BaseState}

function DialogueState:init(text, callback)
    self.textpanel=Panel{x=6,y=VIRTUAL_HEIGHT-134,width=VIRTUAL_WIDTH-12,height=128}
    self.textpanel:addChild(Textbox({x=6,y=VIRTUAL_HEIGHT-134,width=VIRTUAL_WIDTH-12,height=128,message={text=text,font=gFonts.amatic.medium}},function()self.textpanel.visible=false end))
    self.callback = callback or function() end
end

function DialogueState:update(dt)
    self.textpanel:update(dt)

    if not self.textpanel.visible then
       self.callback()
       gStateStack:pop()
    end
end

function DialogueState:render()
    love.graphics.setShader()
    self.textpanel:render()
end