local Window = {}
local api = vim.api

function Window:new(win, buf, managed)
    local w = {}
    setmetatable(w, { __index = self })
    w.win = win
    w.buf = buf
    w.managed = managed
    return w
end

function Window:getBufferId()
    return self.buf:getId()
end

function Window:getBuffer()
    return self.buf
end

function Window:getWidth()
    return api.nvim_win_get_width(self.win)
end

function Window:getWindowId()
    return self.win
end

function Window:isManaged()
    return self.managed
end

function Window:setWidth(w)
    self.width = w
    return self
end

function Window:verticalResize()
    api.nvim_win_set_width(self.win, self.width)
end

function Window:scrollBind(bind)
    local current = api.nvim_get_current_win()
    api.nvim_set_current_win(self.win)
    if bind then
        vim.cmd('set scrollbind')
    else
        vim.cmd('set noscrollbind')
    end
    api.nvim_set_current_win(current)
end

function Window:readonly(readonly)
local current = api.nvim_get_current_win()
    api.nvim_set_current_win(self.win)
    if readonly then
        vim.cmd('set readonly')
    else
        vim.cmd('set noreadonly')
    end
    api.nvim_set_current_win(current)
end

return Window

