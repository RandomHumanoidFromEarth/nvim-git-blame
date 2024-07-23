local unit = require('luaunit')

-- mock: vim.api
local ApiMock = {
    expect = {
        buffer = nil,
        from = nil,
        to = nil,
        strict_indexing = nil,
        return_value = nil,
    }
}
function ApiMock.nvim_buf_get_lines(buffer, from, to, strict_indexing)
    unit.assertEquals(buffer, ApiMock.expect.buffer)
    unit.assertEquals(from, ApiMock.expect.from)
    unit.assertEquals(to, ApiMock.expect.to)
    unit.assertEquals(strict_indexing, ApiMock.expect.strict_indexing)
    return ApiMock.expect.return_value
end

vim = { api = ApiMock }
local Buffer = require '../../lua/nvim-git-blame/buffer'

-- this is the naming schema, class definition
TestBuffer = {}

function TestBuffer.TestNew()
    local buf_1 = Buffer:new(0)
    local buf_2 = Buffer:new(1)
    unit.assertEquals(buf_1:getId(), 0)
    unit.assertEquals(buf_2:getId(), 1)
end

function TestBuffer.TestGetLine()
    ApiMock.expect.buffer = 1001
    ApiMock.expect.from = 14
    ApiMock.expect.to = 15
    ApiMock.expect.strict_indexing = true
    ApiMock.expect.return_value = { "first line" }
    local buf = Buffer:new(1001)
    local line = buf:getLine(15)
    unit.assertEquals("first line", line)
end

function TestBuffer.TestGetLines()
    ApiMock.expect.buffer = 1003
    ApiMock.expect.from = 0
    ApiMock.expect.to = -1
    ApiMock.expect.strict_indexing = true
    ApiMock.expect.return_value = { "line_1", "line_2", "line_3" }
    local buf = Buffer:new(1003)
    local lines = buf:getLines()
    unit.assertEquals(lines[1], "line_1")
    unit.assertEquals(lines[2], "line_2")
    unit.assertEquals(lines[3], "line_3")
end

