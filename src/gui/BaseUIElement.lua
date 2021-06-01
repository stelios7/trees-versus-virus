BaseUIElement = Class{}

function BaseUIElement:update(dt) return print('base') end 
function BaseUIElement:addChild() end
function BaseUIElement:getChildren() return nil end
function BaseUIElement:setParent(parent)self.parent = parent end
function BaseUIElement:getParent() return nil end
function BaseUIElement:createNewParent(a)local b=Panel{x=a.x,y=a.y,width=a.width,height=a.height}return b end