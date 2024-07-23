local unit = require 'luaunit'

-- mock: vim.api
local ApiMock = { expect_lines = nil, next_buf_id = 0 }
function ApiMock:setExpectLines(lines)
    self.expect_lines = lines
end
function ApiMock.nvim_create_buf(listed, scratch)
    unit.assertTrue(listed)
    unit.assertTrue(scratch)
    local id = ApiMock.next_buf_id
    ApiMock.next_buf_id = id + 1
    return id
end
function ApiMock.nvim_buf_set_lines(buf, from, to, strict_indexing, replace)
    unit.assertEquals(ApiMock.next_buf_id -1, buf)
    unit.assertEquals(from, 0)
    unit.assertEquals(to, -1)
    unit.assertEquals(strict_indexing, false)
    unit.assertEquals(replace, ApiMock.expect_lines)
end

vim = { api = ApiMock }
local BlameBuffer = require '../../lua/nvim-git-blame/blame-buffer'
TestBlameBuffer = {}

function TestBlameBuffer.TestBlameBuffer()
    local blames = {}
    table.insert(blames, {
        hash = 'abcde',
        user = 'mosix',
        date = '2024-07-01',
        time = '22:00',
        timezone = 'local',
    })
    table.insert(blames, {
        hash = 'af82d',
        user = 'slurp',
        date = '2024-07-02',
        time = '21:00',
        timezone = 'diff',
    })
    ApiMock:setExpectLines({
        "abcde mosix 2024-07-01 22:00 local",
        "af82d slurp 2024-07-02 21:00 diff",
    })
    local blame_buf = BlameBuffer:create(blames)
    unit.assertEquals(blame_buf:getBuffer(), ApiMock.next_buf_id - 1)
    unit.assertEquals(blame_buf:getMaxLen(), 34)
end

