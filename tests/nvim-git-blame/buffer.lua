local test = require('luaunit')


-- mocking vim api
local buf = 999
local mock = {}
function mock.nvim_create_buf(listed, scratch)
    test.assertTrue(listed)
    test.assertTrue(scratch)
    return buf
end
function mock.nvim_buf_set_lines(bufid, start, endpos, strict_indexing, replace)
    test.assertEquals(bufid, buf)
    test.assertEquals(start, 0)
    test.assertEquals(endpos, -1)
    test.assertEquals(strict_indexing, false)
    test.assertEquals({'db1a378 mosix 2024-05-18 17:49:11 +0200'}, replace)
end

TestBuffer = {}
function TestBuffer:setUp()
    _G.vim = {}
    _G.vim.api = mock
    self.buffer= require '../../lua/nvim-git-blame/buffer'
end

function TestBuffer.tearDown()
    _G.vim = nil
end

function TestBuffer:testCreateFromParsed()
    local blames = {}
    table.insert(blames, {
        hash = 'db1a378',
        user = 'mosix',
        date = '2024-05-18',
        time = '17:49:11',
        timezone = '+0200'
    })
    test.assertEquals(self.buffer.create(blames), buf)
end
