local test = require('luaunit')

TestWindowManager = {}

function TestWindowManager:setUp()
    self.window_manager = require '../../lua/nvim-git-blame/window-manager'
end

function TestWindowManager:testWindowList()
    local set
    self.window_manager:add(1, 2)
    self.window_manager:add(3, 4)
    -- first set, window is blame
    set = self.window_manager:get(1)
    test.assertEquals(1, set.buf_blame)
    test.assertEquals(2, set.buf_code)
    -- first set, window is code
    set = self.window_manager:get(2)
    test.assertEquals(1, set.buf_blame)
    test.assertEquals(2, set.buf_code)
    -- second set, window is blame
    set = self.window_manager:get(3)
    test.assertEquals(3, set.buf_blame)
    test.assertEquals(4, set.buf_code)
    -- second set, window is code
    set = self.window_manager:get(4)
    test.assertEquals(3, set.buf_blame)
    test.assertEquals(4, set.buf_code)
end

