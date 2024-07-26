local unit = require 'luaunit'

-- naming schema, not a window object
TestWindowPair = {}

function TestWindowPair:setUp()
    vim = require '../../tests/mock/vim'
    self.window = require '../../tests/mock/window'
    self.sut = require '../../lua/nvim-git-blame/window-pair'
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
    vim.api.expectGetCursor(1002, {23, 8})
    -- scrollbind false
    win_code:expectScrollBind(false)
    win_blame:expectScrollBind(false)
    -- pair: set cursor position
    vim.api.expectSetCursor(1002, {1, 0})
    vim.api.expectSetCursor(1008, {1, 0})
    vim.api.expectSetCursor(1009, {23, 0})
    vim.api.expectSetCursor(1010, {23, 0})
    -- scrollbind true
    vim.api.expectWinSetCurrent(1002)
    win_code:expectScrollBind(false)
    win_code:expectScrollBind(false)
    pair:sync()
end

