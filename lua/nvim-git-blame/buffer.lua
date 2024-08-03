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
    local line = api.nvim_buf_get_lines(self.buf_id, line_number -1, line_number, true)
    return line[1]
end

function Buffer:getLines()
    return api.nvim_buf_get_lines(self.buf_id, 0, -1, true)
end

return Buffer

