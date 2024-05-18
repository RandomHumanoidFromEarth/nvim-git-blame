local WindowManager = {}
WindowManager.win_map = {}

function WindowManager:add(buf_blame, buf_code)
    table.insert(self.win_map, {
        buf_blame = buf_blame,
        buf_code = buf_code
    })
end

function WindowManager:get(buf_id)
    for _, item in pairs(self.win_map) do
        if buf_id == item.buf_blame then
            return item
        end
        if buf_id == item.buf_code then
            return item
        end
    end
    return nil
end

return WindowManager
