local M = {}

local resize = 60
function M.set_width(width)
    resize = width
end

local api = vim.api
local win
local buf

function M.open(buffer)
    buf = buffer
    vim.cmd('vsplit')
    win = api.nvim_get_current_win()
    vim.cmd("vertical resize " .. resize)
    api.nvim_win_set_buf(win, buf)
end

function M.close()
    if nil ~= win then
        api.nvim_win_close(win, false)
        win = nil
    end
    if nil ~= buf then
        api.nvim_buf_delete(buf, {force=true})
        buf = nil
    end
end

function M.is_open()
    return nil ~= win
end

return M

