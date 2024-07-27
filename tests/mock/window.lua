local unit = require 'luaunit'

local Window = {}

function Window:new(win, buf, is_blame_window)
    local w = {}
    setmetatable(w, { __index = self })
    w.managed = is_blame_window
    w.win = win
    w.width = 50
    w.buf = buf
    w.asserts = {
        scrollbind = {}
    }
    return w
end

function Window:getBuffer()
    return self.buf
end

function Window:getBufferId()
    return self.buf:getId()
end

function Window:setWidth(width)
    self.width = width
end

function Window:getWidth()
    return self.width
end

function Window:tearDown()
    local count = 0
    for _ in pairs(self.asserts.scrollbind) do
        count = count + 1
    end
    unit.assertEquals(0, count)
    self.asserts.scrollbind = {}
end

function Window:getWindowId()
    return self.win
end

function Window:isManaged()
    return self.managed
end

function Window:expectScrollBind(bind)
    table.insert(self.asserts.scrollbind, bind)
end

function Window:scrollBind(bind)
    unit.assertEquals(bind, self.asserts.scrollbind[1])
    table.remove(self.asserts.scrollbind, 1)
end

return Window

