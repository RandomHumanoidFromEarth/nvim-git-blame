local M = {}

local api = vim.api
local blame = require 'nvim-git-blame/blame'
local buffer = require 'nvim-git-blame/buffer'
local window = require 'nvim-git-blame/window'

function M.setup(config)
    if nil == config then
        return
    end
    if config.width then
        window.set_width(config.width)
    end
end

-- TODO:
-- parallel scrolling in both windows
-- open more than one window :split and both can scroll
-- format date-time option (or add timezone)

local function open_blame()
    local current_buffer = api.nvim_get_current_buf()
    local file = api.nvim_buf_get_name(current_buffer)
    local blames = blame.blame(file)
    print(blames[0]["user"])
    local buf = buffer.create(blames)
    window.open(buf)
end

local function toggle()
    if window.is_open() then
        window.close()
        return
    end
    open_blame()
end

api.nvim_create_user_command("GitBlameOpen", open_blame, {})
api.nvim_create_user_command("GitBlameClose", window.close, {})
api.nvim_create_user_command("GitBlameToggle", toggle, {})

return M

