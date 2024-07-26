local unit = require 'luaunit'

TestWindow = {}

function TestWindow:setUp()
    vim = require '../../tests/mock/vim'
    self.sut = require '../../lua/nvim-git-blame/window'
    self.buffer = require '../../lua/nvim-git-blame/buffer'
    self.window = require '../../lua/nvim-git-blame/window'
end

function TestWindow.tearDown()
    vim.tearDown()
end

function TestWindow:TestProperties()
    vim.api.expectWinGetWidth(1000, 50)
    local buf = self.buffer:new(3)
    local win = self.window:new(1000, buf, true)
    unit.assertEquals(win:getBufferId(), 3)
    unit.assertEquals(win:getBuffer(), buf)
    unit.assertEquals(win:getWidth(), 50)
    unit.assertEquals(win:getWindowId(), 1000)
    unit.assertEquals(win:isManaged(), true)
    win:setWidth(35)
    unit.assertEquals(win.width, 35)
end

function TestWindow:TestVerticalResize()
    vim.api.expectWinSetWidth(1004, 20)
    local buf = self.buffer:new(4)
    local win = self.window:new(1004, buf, true)
    win:setWidth(20)
    win:verticalResize()
end

function TestWindow:TestScrollbind()
    vim.api.expectWinGetCurrent(1002)
    vim.api.expectWinSetCurrent(1000)
    vim.expectCmd("set scrollbind")
    vim.api.expectWinSetCurrent(1002)
    local win = self.window:new(1000)
    win:scrollBind(true)
    vim.api.expectWinGetCurrent(1015)
    vim.api.expectWinSetCurrent(1000)
    vim.expectCmd("set noscrollbind")
    vim.api.expectWinSetCurrent(1015)
    win:scrollBind(false)
end


function TestWindow:TestReadonly()
    vim.api.expectWinGetCurrent(1002)
    vim.api.expectWinSetCurrent(1000)
    vim.expectCmd("set readonly")
    vim.api.expectWinSetCurrent(1002)
    local win = self.window:new(1000)
    win:readonly(true)
    vim.api.expectWinGetCurrent(1015)
    vim.api.expectWinSetCurrent(1000)
    vim.expectCmd("set noreadonly")
    vim.api.expectWinSetCurrent(1015)
    win:readonly(false)
end
