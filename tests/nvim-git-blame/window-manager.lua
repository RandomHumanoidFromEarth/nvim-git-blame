local test = require('luaunit')

TestWindowManager = {}

function TestWindowManager:setUp()
    self.window_manager = require '../../lua/nvim-git-blame/window-manager'
end

function TestWindowManager:testGet()
    self.window_manager:reset()
    local set
    self.window_manager:add(1, 2)
    self.window_manager:add(3, 4)
    -- first set, window is blame
    set = self.window_manager:get(1)
    test.assertEquals(set.buf_blame, 1)
    test.assertEquals(set.buf_code, 2)
    -- first set, window is code
    set = self.window_manager:get(2)
    test.assertEquals(set.buf_blame, 1)
    test.assertEquals(set.buf_code, 2)
    -- second set, window is blame
    set = self.window_manager:get(3)
    test.assertEquals(set.buf_blame, 3)
    test.assertEquals(set.buf_code, 4)
    -- second set, window is code
    set = self.window_manager:get(4)
    test.assertEquals(set.buf_blame, 3)
    test.assertEquals(set.buf_code, 4)
end

function TestWindowManager:testRemove()
    self.window_manager:reset()
    self.window_manager:add(1, 2)
    self.window_manager:add(3, 4)
    self.window_manager:remove(3)
    test.assertNil(self.window_manager:get(3), nil)
    test.assertNil(self.window_manager:get(4), nil)
    local set = self.window_manager:get(1)
    test.assertEquals(1, set.buf_blame)
    test.assertEquals(2, set.buf_code)
end

