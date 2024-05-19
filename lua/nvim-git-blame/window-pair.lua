local WindowPair = {}

function WindowPair:new(win_1, win_2)
    local pair = {}
    setmetatable(pair, { __index = self })
    pair.win_1 = win_1
    pair.win_2 = win_2
    return pair
end

function WindowPair:contains(win)
    if win == self.win_1 then
        return true
    end
    if win == self._win_2 then
        return true
    end
    return false
end

function WindowPair:getManagedWindow()
    if self.win_1:isManaged() then
        return self.win_1
    end
    return self.win_2
end

function WindowPair:getUnmanagedWindow()
    if self.win_1:isManaged() then
        return self.win_2
    end
    return self.win_1
end

function WindowPair:scrollBind(bind)
    self.win_1:scrollBind(bind)
    self.win_2:scrollBind(bind)
end

return WindowPair

