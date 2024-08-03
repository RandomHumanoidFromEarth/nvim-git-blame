local unit = require 'luaunit'

-- naming schema, not a window object
TestWindowPair = {}

function TestWindowPair:setUp()
    vim = require '../../tests/mock/vim'
    self.window = require '../../tests/mock/window'
    self.buffer = require '../../tests/mock/buffer'
    self.sut = require '../../lua/nvim-git-blame/window-pair'
end

function TestWindowPair.tearDown()
    vim.tearDown()
end

function TestWindowPair:TestCreation()
    local pair_1 = self.sut:new(self.window:new(1, 1, true), self.window:new(2, 2, false))
    local pair_2 = self.sut:new(self.window:new(3, 3, true), self.window:new(4, 4, false))
    unit.assertEquals(1, pair_1:getManagedWindow():getWindowId())
    unit.assertEquals(2, pair_1:getUnmanagedWindow():getWindowId())
    unit.assertEquals(3, pair_2:getManagedWindow():getWindowId())
    unit.assertEquals(4, pair_2:getUnmanagedWindow():getWindowId())
end

function TestWindowPair:testSync()
    local win_code = self.window:new(1001, 1, false)
    local win_blame = self.window:new(1002, 2, true)
    local pair = self.sut:new(win_code, win_blame)
    -- pair: get current cursor position
    vim.api.expectGetCursor(1001, {23, 8})
    -- scrollbind false
    win_code:expectScrollBind(false)
    win_blame:expectScrollBind(false)
    -- pair: set cursor position
    vim.api.expectSetCursor(1002, {1, 0})
    vim.api.expectSetCursor(1001, {1, 0})
    vim.api.expectSetCursor(1002, {23, 0})
    vim.api.expectSetCursor(1001, {23, 0})
    -- scrollbind true
    win_code:expectScrollBind(true)
    win_blame:expectScrollBind(true)
    pair:sync()
end

function TestWindowPair:TestAddEmptyLinesToBlameBuffer()
    local code_buf = self.buffer:new(1)
    code_buf:expectGetLines({
        "first line",  -- 10
        "second line", -- 11
        "third line",   -- 10
    })
    local blame_buf = self.buffer:new(2)
    blame_buf:expectGetLine(1, "first blame")
    blame_buf:expectGetLine(2, "second blame")
    blame_buf:expectGetLine(3, "third blame")
    local code_win = self.window:new(1000, code_buf, false)
    code_win:setWidth(16)
    local blame_win = self.window:new(1001, blame_buf, true)
    local pair = self.sut:new(code_win, blame_win)
    vim.api.expectBufSetLines(2, 0, -1, true, {
        "first blame",
        "second blame",
        "",
        "third blame",
    })
    pair:addEmptyLinesToBlameBuffer()
    code_buf:tearDown()
    blame_buf:tearDown()
end

