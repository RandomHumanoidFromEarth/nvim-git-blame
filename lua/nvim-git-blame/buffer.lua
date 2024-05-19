local Buffer = {}
local api = vim.api

function Buffer.createFromBlames(blames)
    local buf = api.nvim_create_buf(true, true)
    local content = {}
    for _, blame in pairs(blames) do
        table.insert(content,
            blame.hash .. " " ..
            blame.user .. " " ..
            blame.date .. " " ..
            blame.time .. " " ..
            blame.timezone
        )
    end
    api.nvim_buf_set_lines(buf, 0, -1, false, content)
    return buf
end

return Buffer
