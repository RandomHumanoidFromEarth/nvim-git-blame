local unit = require 'luaunit'

-- mock: vim.api
local ApiMock = {}
function ApiMock.nvim_list_wins()
    return {1000, 1001, 1002}
end

-- mock: window
local Window = {}
function Window:new(win, buf)
    local w = {}
    setmetatable(w, { __index = self })
    w.win = win
    w.buf = buf
    return w
end
function Window:getWindowId()
    return self.win
end
function Window:getBufferId()
    return self.buf
end

-- mock: pair
local Pair = {}
function Pair:new(win_1, win_2)
    local pair = {}
    setmetatable(pair, { __index = self })
    pair.win_1 = win_1
    pair.win_2 = win_2
    return pair
end

vim = { api = ApiMock }
local WindowManager = require '../../lua/nvim-git-blame/window-manager'
TestWindowManager = {}

function TestWindowManager.TestAddAndRemovePairs()
    local pair_1_win_1 = Window:new(1000, 1)
    local pair_1_win_2 = Window:new(1001, 2)
    local pair_1 = Pair:new(pair_1_win_1, pair_1_win_2)
    local pair_2_win_1 = Window:new(1002, 3)
    local pair_2_win_2 = Window:new(1003, 4)
    local pair_2 = Pair:new(pair_2_win_1, pair_2_win_2)
    WindowManager:addPair(pair_1)
    WindowManager:addPair(pair_2)
    unit.assertNotNil(WindowManager:getPairByWindowId(1000))
    unit.assertNotNil(WindowManager:getPairByWindowId(1001))
    unit.assertNotNil(WindowManager:getPairByWindowId(1002))
    unit.assertNotNil(WindowManager:getPairByWindowId(1003))
    unit.assertNotNil(WindowManager:getPairByBufferId(1))
    unit.assertNotNil(WindowManager:getPairByBufferId(2))
    unit.assertNotNil(WindowManager:getPairByBufferId(3))
    unit.assertNotNil(WindowManager:getPairByBufferId(4))
    WindowManager:removePairByBufferId(1)
    unit.assertNil(WindowManager:getPairByWindowId(1000))
    unit.assertNil(WindowManager:getPairByWindowId(1001))
    unit.assertNil(WindowManager:getPairByBufferId(1))
    unit.assertNil(WindowManager:getPairByBufferId(2))
    unit.assertNotNil(WindowManager:getPairByWindowId(1002))
    unit.assertNotNil(WindowManager:getPairByWindowId(1003))
    unit.assertNotNil(WindowManager:getPairByBufferId(3))
    unit.assertNotNil(WindowManager:getPairByBufferId(4))
    WindowManager:addPair(pair_1)
    WindowManager:removePairByBufferId(2)
    unit.assertNil(WindowManager:getPairByWindowId(1000))
    unit.assertNil(WindowManager:getPairByWindowId(1001))
    unit.assertNil(WindowManager:getPairByBufferId(1))
    unit.assertNil(WindowManager:getPairByBufferId(2))
    unit.assertNotNil(WindowManager:getPairByWindowId(1002))
    unit.assertNotNil(WindowManager:getPairByWindowId(1003))
    unit.assertNotNil(WindowManager:getPairByBufferId(3))
    unit.assertNotNil(WindowManager:getPairByBufferId(4))
    WindowManager:addPair(pair_1)
    WindowManager:removePairByWindowId(1002)
    unit.assertNotNil(WindowManager:getPairByWindowId(1000))
    unit.assertNotNil(WindowManager:getPairByWindowId(1001))
    unit.assertNil(WindowManager:getPairByWindowId(1002))
    unit.assertNil(WindowManager:getPairByWindowId(1003))
    unit.assertNotNil(WindowManager:getPairByBufferId(1))
    unit.assertNotNil(WindowManager:getPairByBufferId(2))
    unit.assertNil(WindowManager:getPairByBufferId(3))
    unit.assertNil(WindowManager:getPairByBufferId(4))
end

function TestWindowManager.TestWindowExists()
    unit.assertTrue(WindowManager.windowExists(1001))
    unit.assertFalse(WindowManager.windowExists(1003))
end

