StateStack = Class{}

function StateStack:init()
    self.states = {}
end

function StateStack:update(dt)
    self.states[#self.states]:update(dt)
end

function StateStack:processAI(params, dt)
    self.states[#self.states]:processAI(params,dt)
end

function StateStack:render()
    for i, state in ipairs(self.states) do
        state:render()
    end
end

--[[
    Clears the states list
]]
function StateStack:clear()
    self.states = {}
end

--[[
    Pushes a new state on top of the stack
]]
function StateStack:push(state)
    table.insert(self.states, state)
    state:enter()
end

--[[
    Pops the top most stack, so we can return to the previous
]]
function StateStack:pop()
    self.states[#self.states]:exit()
    table.remove(self.states)
end

function StateStack:countStates()
    return #self.states
end