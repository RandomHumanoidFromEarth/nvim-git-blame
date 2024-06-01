local Buffer = require 'nvim-git-blame/buffer'

local WindowPair = {}
local api = vim.api

function WindowPair:new(win_1, win_2)
    local pair = {}
    setmetatable(pair, { __index = self })
    pair.win_1 = win_1
    pair.win_2 = win_2
    local blame_window = win_1
    if win_2:isManaged() then
        blame_window = win_2
    end
    local original_blame_buf = api.nvim_create_buf(true, true)
    api.nvim_buf_set_lines(original_blame_buf, 0, -1, false, blame_window:getBuffer():getLines())
    pair.original_blame_buf = Buffer:new(original_blame_buf)
    return pair
end

function WindowPair:getOriginalBlameBuffer()
    return self.original_blame_buf
end

-- scroll  to top to sync and set position
function WindowPair:sync()
    local pos = api.nvim_win_get_cursor(self:getUnmanagedWindow():getWindowId())
    self:wrappedLines()
    self:scrollBind(false)
    api.nvim_win_set_cursor(self:getManagedWindow():getWindowId(), {1, 0})
    api.nvim_win_set_cursor(self:getUnmanagedWindow():getWindowId(), {1, 0})
    api.nvim_win_set_cursor(self:getManagedWindow():getWindowId(), {pos[1], 0})
    api.nvim_win_set_cursor(self:getUnmanagedWindow():getWindowId(), {pos[1], 0})
    self:scrollBind(true)
end

function WindowPair:wrappedLines()
    local code_window = self:getUnmanagedWindow()
    local blame_window = self:getManagedWindow()
    local new_blame_buffer = {}
    local code_buffer_lines = code_window:getBuffer():getLines()
    for index, line in pairs(code_buffer_lines) do
        table.insert(new_blame_buffer, self:getOriginalBlameBuffer():getLine(index))
        local wrapped_lines = (string.len(line) / code_window:getWidth()) -1
        if wrapped_lines > 0 then
            for _=0, wrapped_lines do
                table.insert(new_blame_buffer, '')
            end
        end
    end
    api.nvim_buf_set_lines(blame_window:getBufferId(), 0, -1, true, new_blame_buffer)
end

function WindowPair:hasBufferId(buf_id)
    if buf_id == self.win_1:getBufferId() then
        return true
    end
    if buf_id == self.win_2:getBufferId() then
        return true
    end
    return false
end

function WindowPair:hasWindowId(win_id)
    if win_id == self.win_1:getWindowId() then
        return true
    end
    if win_id == self.win_2:getWindowId() then
        return true
    end
    return false
end

function WindowPair:getManagedWindow()
    if self.win_1:isManaged() then
        return self.win_1
    end
    return self.win_2
end

function WindowPair:getUnmanagedWindow()
    if self.win_1:isManaged() then
        return self.win_2
    end
    return self.win_1
end

function WindowPair:scrollBind(bind)
    self.win_1:scrollBind(bind)
    self.win_2:scrollBind(bind)
end

return WindowPair

