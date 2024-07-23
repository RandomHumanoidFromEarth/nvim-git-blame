local unit = require('luaunit')
vim = { api = {} }
local Buffer = require '../../lua/nvim-git-blame/buffer'

-- this is the naming schema, class definition
TestBuffer = {}

function TestBuffer:setUp()
    self.expect = {
        buffer = nil,
        from = nil,
        to = nil,
        strict_indexing = nil,
        return_value = nil,
    }
    function vim.api.nvim_buf_get_lines(buffer, from, to, strict_indexing)
        unit.assertEquals(buffer, self.expect.buffer)
        unit.assertEquals(from, self.expect.from)
        unit.assertEquals(to, self.expect.to)
        unit.assertEquals(strict_indexing, self.expect.strict_indexing)
        return self.expect.return_value
    end
end

function TestBuffer.TestNew()
    local buf_1 = Buffer:new(0)
    local buf_2 = Buffer:new(1)
    unit.assertEquals(buf_1:getId(), 0)
    unit.assertEquals(buf_2:getId(), 1)
end

function TestBuffer:TestGetLine()
    self.expect.buffer = 1001
    self.expect.from = 14
    self.expect.to = 15
    self.expect.strict_indexing = true
    self.expect.return_value = { "first line" }
    local buf = Buffer:new(1001)
    local line = buf:getLine(15)
    unit.assertEquals("first line", line)
end

function TestBuffer:TestGetLines()
    self.expect.buffer = 1003
    self.expect.from = 0
    self.expect.to = -1
    self.expect.strict_indexing = true
    self.expect.return_value = { "line_1", "line_2", "line_3" }
    local buf = Buffer:new(1003)
    local lines = buf:getLines()
    unit.assertEquals(lines[1], "line_1")
    unit.assertEquals(lines[2], "line_2")
    unit.assertEquals(lines[3], "line_3")
end

