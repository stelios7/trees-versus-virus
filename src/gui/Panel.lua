Panel = Class{__includes = BaseUIElement}

function Panel:init(def)
    self.parent = def.parent or nil
    self.children = {}
    
    if self.parent then
        self.x = def.x + self.parent.x
        self.offsetX = def.x
        
        self.y = def.y + self.parent.y
        print(self.x)
    else
        self.x = def.x
        self.y = def.y
    end

    self.width = def.width
    self.height = def.height

    self.background=def.background or{r=56/255,g=56/255,b=56/255}
    
    self.linked = def.linked or false
    self.visible = true
end

function Panel:addChild(child)
    self.children[#self.children+1] = child
    child:setParent(self)
end

function Panel:update(dt)
    if self.linked then
        self.x = self.parent.x + self.offsetX
    end
    for i, child in ipairs(self.children) do
        child:update(dt)
    end
end

function Panel:render()
    if self.visible then love.graphics.setShader()love.graphics.setColor(1,1,1,1)love.graphics.rectangle('fill',self.x,self.y,self.width,self.height,3)love.graphics.setColor(self.background.r,self.background.g,self.background.b,1)love.graphics.rectangle('fill',self.x+2,self.y+2,self.width-4,self.height-4,3)love.graphics.setColor(1,1,1,1)for a,b in ipairs(self.children)do b:render()end end
end

function Panel:toggle()
    self.visible = not self.visible
end

function Panel:speak()
    print('i\'m a panel')
end