local WindowPair = {}
local api = vim.api

function WindowPair:new(win_1, win_2)
    local pair = {}
    setmetatable(pair, { __index = self })
    pair.win_1 = win_1
    pair.win_2 = win_2
    return pair
end

-- scroll lower one to top to sync and set position
function WindowPair:sync()
    local pos = api.nvim_win_get_cursor(self:getUnmanagedWindow():getWindowId())
    self:scrollBind(false)
    api.nvim_win_set_cursor(self:getManagedWindow():getWindowId(), {1, 0})
    api.nvim_win_set_cursor(self:getUnmanagedWindow():getWindowId(), {1, 0})
    api.nvim_win_set_cursor(self:getManagedWindow():getWindowId(), {pos[1], 0})
    api.nvim_win_set_cursor(self:getUnmanagedWindow():getWindowId(), {pos[1], 0})
    self:scrollBind(true)

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

