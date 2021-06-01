Label = Class{__includes = BaseUIElement}

function Label:init(def)
    self.parent=def.parent
    
    self.x = def.x + self.parent.x
    self.offsetX = def.x

    self.y = def.y + self.parent.y

    self.width = def.width
    self.height = def.height

    self.message={text=def.msg.text,font=def.msg.font,alignment=def.msg.alignment}

    self.linked = true
    self.visible = true
end

function Label:update(dt)
    if self.linked then
        -- follow parent movement
        self.x = self.parent.x + self.offsetX
    end    
end

function Label:render()
    if self.visible then love.graphics.setFont(self.message.font)love.graphics.printf(self.message.text,self.x+2,self.y+2,self.width-4,self.message.alignment)end
end