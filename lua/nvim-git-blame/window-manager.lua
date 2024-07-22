local WindowManager = {}
WindowManager.pairs = {}
local api = vim.api

function WindowManager:addPair(window_pair)
    table.insert(self.pairs, window_pair)
end

function WindowManager:getPairByBufferId(buf_id)
    for _, item in pairs(self.pairs) do
        if item.win_1:getBufferId() == buf_id then
            return item
        end
        if item.win_2:getBufferId() == buf_id then
            return item
        end
    end
    return nil
end

function WindowManager:getPairByWindowId(win_id)
    for _, item in pairs(self.pairs) do
        if item.win_1:getWindowId() == win_id then
            return item
        end
        if item.win_2:getWindowId() == win_id then
            return item
        end
    end
end

function WindowManager:removePairByBufferId(buf_id)
    for _, item in pairs(self.pairs) do
        if item.win_1:getBufferId() == buf_id then
            table.remove(self.pairs, _)
            return
        end
        if item.win_2:getBufferId() == buf_id then
            table.remove(self.pairs, _)
            return
        end
    end
    return nil
end

function WindowManager:removePairByWindowId(win_id)
    for _, item in pairs(self.pairs) do
        if item.win_1:getWindowId() == win_id then
            table.remove(self.pairs, _)
            return
        end
        if item.win_2:getWindowId() == win_id then
            table.remove(self.pairs, _)
            return
        end
    end
end

function WindowManager.windowExists(win_id)
    for _, w in pairs(api.nvim_list_wins()) do
        if w == win_id then
            return true
        end
    end
    return false
end

function WindowManager:getAll()
    return self.pairs
end

return WindowManager

