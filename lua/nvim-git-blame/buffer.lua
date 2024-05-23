local Buffer = {}
local api = vim.api

function Buffer:new(buf_id)
    local b = {}
    setmetatable(b, { __index = self })
    b.buf_id = buf_id
    return b
end

function Buffer:getId()
    return self.buf_id
end

function Buffer:getLine(line_number)
    local content = api.nvim_buf_get_lines(self.buf_id, 0, -1, true)
    local lines = content:gmatch('([^\n]+)\n?')
    if nil == lines[line_number] then
        return nil
    end
    return lines[line_number]
end

return Buffer
