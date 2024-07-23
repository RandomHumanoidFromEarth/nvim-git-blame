local unit = require('luaunit')
vim = { api = {} }
local Buffer = require '../../lua/nvim-git-blame/buffer'

-- this is the naming schema, class definition
TestBuffer = {}

--function TestBuffer:setUp()
--end

function TestBuffer.tearDown()
    vim.api = {}
end

function TestBuffer.testCreationAndGetId()
    local buf_1 = Buffer:new(0)
    local buf_2 = Buffer:new(1)
    unit.assertEquals(buf_1:getId(), 0)
    unit.assertEquals(buf_2:getId(), 1)
end

function TestBuffer.TestGetLine()
    vim.api.nvim_buf_get_lines = function (buffer, from, to, strict_indexing)
        unit.assertEquals(buffer, 1001)
        unit.assertEquals(from, to - 1)
        unit.assertEquals(to, 15)
        unit.assertEquals(strict_indexing, true)
        return { "first line" }
    end
    local buf = Buffer:new(1001)
    local line = buf:getLine(15)
    unit.assertEquals("first line", line)
end

function TestBuffer.TestGetLines()
    -- FIXME: function from TestGetLine (above test) is called
    vim.api.nvim_buf_get_lines = function (buffer, from, to, strict_indexing)
        unit.assertEquals(buffer, 1003)
        unit.assertEquals(from, 0)
        unit.assertEquals(to, -1)
        unit.assertEquals(strict_indexing, true)
        return { "line_1", "line_2", "line_3" }
    end
    local buf = Buffer:new(1003)
    local lines = buf:getLines()
    unit.assertEquals(lines[1], "line_1")
    unit.assertEquals(lines[2], "line_2")
    unit.assertEquals(lines[3], "line_3")
end

