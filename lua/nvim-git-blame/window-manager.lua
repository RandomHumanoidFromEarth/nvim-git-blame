local M = {}

local win_map = {}

function M.add(buf_blame, buf_code)
    table.insert(win_map, {
        buf_blame = buf_blame,
        buf_code = buf_code
    })
end

function M.get(buf_id)
    for item in win_map do
        if buf_id == item['buf_blame'] then
            return item
        end
        if buf_id == item['buf_code'] then
            return item
        end
    end
    return nil
end

return M
