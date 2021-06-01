Textbox = Class{__includes = BaseUIElement}

function Textbox:init(params, callback)  
    self.x = params.x
    self.y = params.y
    self.width = params.width
    self.height = params.height

    self.text = params.message.text
    self.font = params.message.font
    _, self.textChunks = self.font:getWrap(self.text, self.width - 12)

    self.chunkCounter = 1
    self.endOfText = false
    self.closed = false

    self.parent=params.panel or Panel({x=self.x,y=self.y,width=self.width,height=self.height})

    self.callback = callback or function() end
    self.linked = params.linked or false
    self:next()
end

function Textbox:setParent(parent)
    self.parent = parent
    self.offsetX = self.x - self.parent.x
end

function Textbox:next()
    if self.endOfText then
        self.displayingChunks = {}
        self.callback()
        self.closed = true
    else
        self.displayingChunks = self:nextChunks()
    end
end

function Textbox:nextChunks()
    local chunks = {}

    for i = self.chunkCounter, self.chunkCounter + 2 do
        table.insert(chunks, self.textChunks[i])

        if i == #self.textChunks then
            self.endOfText = true
            return chunks
        end
    end

    self.chunkCounter = self.chunkCounter + 3

    return chunks
end

function Textbox:isClosed()
    return self.closed
end

function Textbox:update(dt)
    if love.keyboard.wasPressed('space') or love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        self:next()
    end

    if self.linked then
        -- follow parent movement
        self.x = self.parent.x + self.offsetX
    end
end

function Textbox:render()
    love.graphics.setFont(self.font)for a=1,#self.displayingChunks do love.graphics.print(self.displayingChunks[a],self.x+3,self.y+3+(a-1)*self.font:getHeight())end
end