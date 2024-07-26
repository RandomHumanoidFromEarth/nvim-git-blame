local unit = require('luaunit')

-- this is the naming schema, class definition
TestBuffer = {}
function TestBuffer:setUp()
    vim = require '../../tests/mock/vim'
    self.sut = require '../../lua/nvim-git-blame/buffer'
end

function TestBuffer.tearDown()
    vim.tearDown()
end

function TestBuffer:TestNew()
    local buf_1 = self.sut:new(0)
    local buf_2 = self.sut:new(1)
    unit.assertEquals(buf_1:getId(), 0)
    unit.assertEquals(buf_2:getId(), 1)
end

function TestBuffer:TestGetLine()
    vim.api.expectBufGetLines(10, 14, 15, true, {"single line"})
    local buf = self.sut:new(10)
    local line = buf:getLine(15)
    unit.assertEquals("single line", line)
end

function TestBuffer:TestGetLines()
    vim.api.expectBufGetLines(13, 0, -1, true, {"line_1", "line_2", "line_3"})
    local buf = self.sut:new(13)
    local lines = buf:getLines()
    unit.assertEquals(lines[1], "line_1")
    unit.assertEquals(lines[2], "line_2")
    unit.assertEquals(lines[3], "line_3")
end

