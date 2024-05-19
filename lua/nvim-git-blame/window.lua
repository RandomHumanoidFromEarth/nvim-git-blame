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
    return self.buf
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
    local current = api.nvim_get_current_win()
    api.nvim_set_current_win(self.win)
    vim.cmd('vertical resize ' .. self.width)
    api.nvim_set_current_win(current)
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

--function M.open(buffer)
--    buf = buffer
--    vim.cmd('vsplit')
--    win = api.nvim_get_current_win()
--    vim.cmd("vertical resize " .. resize)
--    api.nvim_win_set_buf(win, buf)
--end
--
--function M.close()
--    if nil ~= win then
--        api.nvim_win_close(win, false)
--        win = nil
--    end
--    if nil ~= buf then
--        api.nvim_buf_delete(buf, {force=true})
--        buf = nil
--    end
--end
--
--function M.is_open()
--    return nil ~= win
--end
--
--return M

