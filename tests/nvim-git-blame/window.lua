local unit = require 'luaunit'

-- mock: vim.api
local ApiMock = {
    current_win_id = nil,
    expexted_resize = nil,
    widths = {},
    win_jumps = {},
}
function ApiMock:setExpectedResize(s)
    self.expected_resize = s
end
function ApiMock:pretendWindowSize(win_id, s)
    self.widths[win_id] = s
end
function ApiMock.nvim_win_get_width(win_id)
    unit.assertEquals(win_id, ApiMock.current_win_id)
    return ApiMock.widths[win_id]
end
function ApiMock.nvim_win_set_width(win_id, size)
    unit.assertEquals(win_id, ApiMock.current_win_id)
    unit.assertEquals(size, ApiMock.expected_resize)
    return ApiMock.expected_resize
end
function ApiMock.nvim_get_current_win()
    return 999
end
function ApiMock:expectedSwitchWindows(jumps)
    -- boing boing
    self.win_jumps = jumps
end

function ApiMock.nvim_set_current_win(win)
    unit.assertEquals(win, ApiMock.win_jumps[1])
    table.remove(ApiMock.win_jumps, 1)
end

-- mock: buffer
local BufferMock = {}
function BufferMock:new(buf_id)
    local b = {}
    setmetatable(b, { __index = self })
    b.buf_id = buf_id
    return b
end
function BufferMock:getId()
    return self.buf_id
end

vim = { api = ApiMock }
local Window = require '../../lua/nvim-git-blame/window'

TestWindow = {}

function TestWindow.TestProperties()
    ApiMock.current_win_id = 1005
    ApiMock:pretendWindowSize(1005, 50)
    local buf = BufferMock:new(15)
    local win = Window:new(1005, buf, true)
    unit.assertEquals(win:getBufferId(), 15)
    unit.assertEquals(win:getBuffer(), buf)
    unit.assertEquals(win:getWidth(), 50)
    unit.assertEquals(win:getWindowId(), 1005)
    unit.assertEquals(win:isManaged(), true)
end

function TestWindow.TestResize()
    ApiMock.current_win_id = 1006
    local buf = BufferMock:new(16)
    local win = Window:new(1006, buf, true)
    win:setWidth(48)
    ApiMock:setExpectedResize(48)
    win:verticalResize()
end
