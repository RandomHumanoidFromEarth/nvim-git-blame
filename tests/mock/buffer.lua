local unit = require 'luaunit'

local Buffer = {}

function Buffer:new(id)
    local b = {}
    setmetatable(b, { __index = self })
    b.id = id
    b.expect = {}
    b.expect.getlines = {}
    b.expect.getline = {}
    return b
end

function Buffer.count(table)
    local count = 0
    for _ in pairs(table) do
        count = count +1
    end
    return count
end

function Buffer:tearDown()
    unit.assertEquals(0, self.count(self.expect.getlines))
    unit.assertEquals(0, self.count(self.expect.getline))
    self.expect.getlines = {}
    self.expect.getline = {}
end


function Buffer:expectGetLine(index, willReturn)
    table.insert(self.expect.getline, {index, willReturn})
end

function Buffer:getLine(index)
    unit.assertEquals(self.expect.getline[1][1], index)
    local willReturn = self.expect.getline[1][2]
    table.remove(self.expect.getline, 1)
    return willReturn
end

function Buffer:getId()
    return self.id
end

function Buffer:expectGetLines(willReturn)
    table.insert(self.expect.getlines, willReturn)
end

function Buffer:getLines()
    local willReturn = self.expect.getlines[1]
    table.remove(self.expect.getlines, 1)
    return willReturn
end

return Buffer

