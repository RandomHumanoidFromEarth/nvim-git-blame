local M = {}

-- TODO: handle wrapped lines
-- TODO: handle not a written file
-- TODO: handle close with :q
-- TODO: handle removing buffers from nvim_list_bufs()
-- TODO: handle open win from open blame without scrollbind
-- TODO: write tests
-- TODO: manual testing
-- TODO: update readme

local api = vim.api
local git = require 'nvim-git-blame/git'
local buffer = require 'nvim-git-blame/buffer'
local Window = require 'nvim-git-blame/window'
local WindowPair = require 'nvim-git-blame/window-pair'
local wm = require 'nvim-git-blame/window-manager'

function M.setup(config)
    if nil == config then
        return
    end
    -- no configuration yet
end

local function open()
    if false == git.isGit() then
        print('not a git repository')
        return
    end
    -- current window
    local current_buffer = api.nvim_get_current_buf()
    local current_window = api.nvim_get_current_win()
    local window_code = Window:new(current_window, current_buffer, false)
    -- create blame buffer
    local file = api.nvim_buf_get_name(current_buffer)
    local blames = git.blame(file)
    local buf = buffer:createFromBlames(blames)
    -- open new window
    vim.cmd('vsplit')
    local win = api.nvim_get_current_win()
    local window_blame = Window:new(win, buf:getBuffer(), true)
    window_blame:setWidth(buf:getMaxLen() + 5)
    window_blame:verticalResize()
    local pair = WindowPair:new(window_blame, window_code)
    wm:addPair(pair)
    api.nvim_win_set_buf(win, buf:getBuffer())
    window_blame:readonly(true)
end

local function close()
    local current_win = api.nvim_get_current_win()
    local pair = wm:getPairByWindowId(current_win)
    if nil == pair then
        return
    end
    -- remove pair before trigger autocmd - manual handling
    wm:removePairByWindowId(pair.win_1:getWindowId())
    pair:scrollBind(false)
    api.nvim_win_close(pair:getManagedWindow():getWindowId(), true)
    api.nvim_set_current_win(pair:getUnmanagedWindow():getWindowId())
end

local function toggle()
    local current_win = api.nvim_get_current_win()
    local pair = wm:getPairByWindowId(current_win)
    if nil == pair then
        open()
        return
    end
    close()
end

api.nvim_create_autocmd({'BufEnter'}, {
    callback = function(ev)
        local all = wm:getAll()
        for _, pair in pairs(all) do
            pair:getManagedWindow():verticalResize()
            if pair:hasBufferId(ev.buf) then
                pair:sync()
                pair:scrollBind(true)
            else
                pair:scrollBind(false)
            end
        end
    end
})

api.nvim_create_user_command("GitBlameOpen", open, {})
api.nvim_create_user_command("GitBlameClose", close, {})
api.nvim_create_user_command("GitBlameToggle", toggle, {})

return M

