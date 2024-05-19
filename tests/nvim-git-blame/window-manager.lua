local test = require('luaunit')

TestWindowManager = {}

function TestWindowManager:setUp()
    self.window_manager = require '../../lua/nvim-git-blame/window-manager'
    self.window_1 = nil
    self.window_2 = nil
end

function TestWindowManager:reset()
    local window_1 = {}
    function window_1.getBuffer()
        return 1
    end
    function window_1.getCodeBuffer()
        return 2
    end
    local window_2 = {}
    function window_2.getBuffer()
        return 3
    end
    function window_2.getCodeBuffer()
        return 4
    end
    self.window_1 = window_1
    self.window_2 = window_2
    self.window_manager._reset()
    self.window_manager:add(self.window_1)
    self.window_manager:add(self.window_2)
end

function TestWindowManager:testGet()
    self:reset()
    test.assertEquals(self.window_manager:get(1), self.window_1)
    test.assertEquals(self.window_manager:get(2), self.window_1)
    test.assertEquals(self.window_manager:get(3), self.window_2)
    test.assertEquals(self.window_manager:get(4), self.window_2)
end

function TestWindowManager:testRemove()
    self:reset()
    self.window_manager:remove(3)
    test.assertNil(self.window_manager:get(3), nil)
    test.assertNil(self.window_manager:get(4), nil)
    test.assertEquals(self.window_manager:get(1), self.window_1)
    test.assertEquals(self.window_manager:get(2), self.window_1)
end

