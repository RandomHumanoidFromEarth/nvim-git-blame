local M = {}

-- TODO: update on code window write buffer → blame again
-- TODO: write tests
-- TODO: manual testing
-- TODO: update readmessssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss

local api = vim.api
local git = require 'nvim-git-blame/git'
local blame_buffer = require 'nvim-git-blame/blame-buffer'
local Buffer = require 'nvim-git-blame/buffer'
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
    local current_buffer = api.nvim_get_current_buf()
    local file = api.nvim_buf_get_name(current_buffer)
    if false == git.isFile(file) then
        print('file not found')
        return
    end
    if false == git.isGit() then
        print('not a git repository')
        return
    end
    local code_buffer = Buffer:new(current_buffer)
    local window_code = Window:new(api.nvim_get_current_win(), code_buffer, false)
    vim.cmd('vsplit')
    local buf = blame_buffer:create(git.blame(file))
    local window_blame = Window:new(api.nvim_get_current_win(), Buffer:new(buf:getBuffer()), true)
    window_blame:setWidth(buf:getMaxLen() + 5)
    window_blame:verticalResize()
    local pair = WindowPair:new(window_blame, window_code)
    wm:addPair(pair)
    api.nvim_win_set_buf(window_blame:getWindowId(), buf:getBuffer())
    window_blame:readonly(true)
end

local function close()
    local current_win = api.nvim_get_current_win()
    local pair = wm:getPairByWindowId(current_win)
    if nil == pair then
        return
    end
    local managed_window = pair:getManagedWindow():getWindowId()
    if wm.windowExists(managed_window) then
        api.nvim_win_close(managed_window, true)
        api.nvim_set_current_win(pair:getUnmanagedWindow():getWindowId())
    end
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
            if false == wm.windowExists(pair:getManagedWindow():getWindowId()) then
                pair:getUnmanagedWindow():scrollBind(false)
                local b_buf = pair:getManagedWindow():getBufferId()
                vim.cmd.bdelete(b_buf)
                vim.cmd.bdelete(pair:getOriginalBlameBuffer():getId())
                wm:removePairByWindowId(pair:getManagedWindow():getWindowId())
                return
            end
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

