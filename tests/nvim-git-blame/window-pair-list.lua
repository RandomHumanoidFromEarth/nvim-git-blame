local unit = require 'luaunit'
TestWindowPairList = {}

function TestWindowPairList:setUp()
    vim = require '../../tests/mock/vim'
    self.sut = require '../../lua/nvim-git-blame/window-pair-list'
    self.window = require '../../lua/nvim-git-blame/window'
    self.pair = require '../../lua/nvim-git-blame/window-pair'
    self.buffer= require '../../lua/nvim-git-blame/buffer'
end

function TestWindowPairList:TestAddAndRemovePairs()
    local pair_1_win_1 = self.window:new(1000, self.buffer:new(1))
    local pair_1_win_2 = self.window:new(1001, self.buffer:new(2))
    local pair_1 = self.pair:new(pair_1_win_1, pair_1_win_2)
    local pair_2_win_1 = self.window:new(1002, self.buffer:new(3))
    local pair_2_win_2 = self.window:new(1003, self.buffer:new(4))
    local pair_2 = self.pair:new(pair_2_win_1, pair_2_win_2)
    self.sut:addPair(pair_1)
    self.sut:addPair(pair_2)
    unit.assertNotNil(self.sut:getPairByWindowId(1000))
    unit.assertNotNil(self.sut:getPairByWindowId(1001))
    unit.assertNotNil(self.sut:getPairByWindowId(1002))
    unit.assertNotNil(self.sut:getPairByWindowId(1003))
    unit.assertNotNil(self.sut:getPairByBufferId(1))
    unit.assertNotNil(self.sut:getPairByBufferId(2))
    unit.assertNotNil(self.sut:getPairByBufferId(3))
    unit.assertNotNil(self.sut:getPairByBufferId(4))
    self.sut:removePairByBufferId(1)
    unit.assertNil(self.sut:getPairByWindowId(1000))
    unit.assertNil(self.sut:getPairByWindowId(1001))
    unit.assertNil(self.sut:getPairByBufferId(1))
    unit.assertNil(self.sut:getPairByBufferId(2))
    unit.assertNotNil(self.sut:getPairByWindowId(1002))
    unit.assertNotNil(self.sut:getPairByWindowId(1003))
    unit.assertNotNil(self.sut:getPairByBufferId(3))
    unit.assertNotNil(self.sut:getPairByBufferId(4))
    self.sut:addPair(pair_1)
    self.sut:removePairByBufferId(2)
    unit.assertNil(self.sut:getPairByWindowId(1000))
    unit.assertNil(self.sut:getPairByWindowId(1001))
    unit.assertNil(self.sut:getPairByBufferId(1))
    unit.assertNil(self.sut:getPairByBufferId(2))
    unit.assertNotNil(self.sut:getPairByWindowId(1002))
    unit.assertNotNil(self.sut:getPairByWindowId(1003))
    unit.assertNotNil(self.sut:getPairByBufferId(3))
    unit.assertNotNil(self.sut:getPairByBufferId(4))
    self.sut:addPair(pair_1)
    self.sut:removePairByWindowId(1002)
    unit.assertNotNil(self.sut:getPairByWindowId(1000))
    unit.assertNotNil(self.sut:getPairByWindowId(1001))
    unit.assertNil(self.sut:getPairByWindowId(1002))
    unit.assertNil(self.sut:getPairByWindowId(1003))
    unit.assertNotNil(self.sut:getPairByBufferId(1))
    unit.assertNotNil(self.sut:getPairByBufferId(2))
    unit.assertNil(self.sut:getPairByBufferId(3))
    unit.assertNil(self.sut:getPairByBufferId(4))
end

function TestWindowPairList:TestWindowExists()
    vim.api.expectListWins({1001, 1002, 1004, 1005})
    vim.api.expectListWins({1001, 1002, 1004, 1005})
    unit.assertTrue(self.sut.windowExists(1001))
    unit.assertFalse(self.sut.windowExists(1003))
end

