local unit = require 'luaunit'

-- mock: window
local Window = {}
function Window:new(win, buf, managed)
    local w = {}
    setmetatable(w, { __index = self })
    w.win = win
    w.buf = buf
    w.managed = managed
    w.assert_scrollbinds = {}
    return w
end
function Window:getBufferId()
    return self.buf:getId()
end
function Window:getWindowId()
    return self.win
end
function Window:isManaged()
    return self.managed
end
function Window:assertScrollBinds(asserts)
    self.assert_scrollbinds = asserts
end
function Window:scrollBind(bind)
    unit.assertEquals(self.assert_scrollbinds[1], bind)
    table.remove(self.assert_scrollbinds, 1)
end

-- mock: vim.api
local ApiMock = {
    set_cursor_call_count = 0,
    cursor_pos = {6, 4},
}
function ApiMock.nvim_win_get_cursor(win_id)
    -- FIXME: unused argument
    return ApiMock.cursor_pos
end
function ApiMock.nvim_win_set_cursor(win, pos)
    if 0 == ApiMock.set_cursor_call_count then
        unit.assertEquals(win, 1001)
        unit.assertEquals(pos, {1, 0})
    end
    if 1 == ApiMock.set_cursor_call_count then
        unit.assertEquals(win, 1000)
        unit.assertEquals(pos, {1, 0})
    end
    if 2 == ApiMock.set_cursor_call_count then
        unit.assertEquals(win, 1000)
        unit.assertEquals(pos, ApiMock.cursor_pos)
    end
    if 3 == ApiMock.set_cursor_call_count then
        unit.assertEquals(win, 1001)
        unit.assertEquals(pos, ApiMock.cursor_pos)
    end
end

vim = { api = ApiMock }
local WindowPair = require '../../lua/nvim-git-blame/window-pair'

-- naming schema, not a window object
TestWindowPair = {}

function TestWindowPair.TestCreation()
    local pair_1 = WindowPair:new(Window:new(1, 1, true), Window:new(2, 2, false))
    local pair_2 = WindowPair:new(Window:new(3, 3, true), Window:new(4, 4, false))
    unit.assertEquals(1, pair_1:getManagedWindow():getWindowId())
    unit.assertEquals(2, pair_1:getUnmanagedWindow():getWindowId())
    unit.assertEquals(3, pair_2:getManagedWindow():getWindowId())
    unit.assertEquals(4, pair_2:getUnmanagedWindow():getWindowId())
end




