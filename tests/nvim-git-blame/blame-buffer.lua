local unit = require 'luaunit'
TestBlameBuffer = {}

function TestBlameBuffer:setUp()
    vim = require '../../tests/mock/vim'
    self.sut = require '../../lua/nvim-git-blame/blame-buffer'
end

function TestBlameBuffer.tearDown()
    vim.tearDown()
end

function TestBlameBuffer:TestBlameBuffer()
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
    vim.api.expectBufCreate(true, true, 15)
    vim.api.expectBufSetLines(15, 0, -1, false, {
        "abcde mosix 2024-07-01 22:00 local",
        "af82d slurp 2024-07-02 21:00 diff",
    })
    local blame_buf = self.sut:create(blames)
    unit.assertEquals(blame_buf:getBuffer(), 15)
    unit.assertEquals(blame_buf:getMaxLen(), 34)
end

