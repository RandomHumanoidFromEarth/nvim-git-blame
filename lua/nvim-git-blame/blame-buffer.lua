local BlameBuffer = {}
local api = vim.api

function BlameBuffer:create(blames)
    local o = {}
    setmetatable(o, { __index = self })
    o.max_len = 0
    local buf = api.nvim_create_buf(true, true)
    local content = {}
    for _, blame in pairs(blames) do
        local line = blame.hash .. " " ..
            blame.user .. " " ..
            blame.date .. " " ..
            blame.time .. " " ..
            blame.timezone
        table.insert(content, line)
        local line_len = string.len(line)
        if line_len > o.max_len then
            o.max_len = line_len
        end
    end
    api.nvim_buf_set_lines(buf, 0, -1, false, content)
    o.buffer = buf
    return o
end

function BlameBuffer:getBuffer()
    return self.buffer
end

function BlameBuffer:getMaxLen()
    return self.max_len
end

return BlameBuffer
