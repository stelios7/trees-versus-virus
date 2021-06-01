Icon = Class{__includes = BaseUIElement}

local _dt = 0

function Icon:init(def)
    self.x = def.x
    self.y = def.y

    self.texture = def.texture
    self.frame = def.frame or nil
    self.shader = def.shader or nil
    
    self.scaleX = def.scaleX or 1
    self.scaleY = def.scaleY or 1
end

function Icon:update(dt)
    _dt = _dt + dt
end

function Icon:render()
    if self.shader then
        love.graphics.setShader(self.shader)
        self.shader:send('u_time', _dt)
    end
    
    if self.frame then
        love.graphics.draw(self.texture, self.frame, self.x, self.y, 0, self.scaleX, self.system)
    else
        love.graphics.draw(self.texture, self.x, self.y, 0, self.scaleX, self.scaleY)
    end
    love.graphics.setShader()

end