local unit = require('luaunit')
TestGit = {}

function TestGit:setUp()
    self.git = require '../../lua/nvim-git-blame/git'
    self.io = require '../../tests/mock/io'
    self.handle = require '../../tests/mock/handle'
    self.git.setIO(self.io)
    self.handles = {}
end

function TestGit:tearDown()
    self.io.tearDown()
    for _, h in pairs(self.handles) do
        h:tearDown()
    end
    self.handles = {}
end

function TestGit:createHandle()
    local handle = self.handle:new()
    table.insert(self.handles, handle)
    return handle
end

function TestGit:TestBlameMovedFile()
    local handle = self:createHandle()
    handle:expectRead("*a", '37950820 classes/database.py (mosix 2019-10-03 18:06:46 +0200  1) ' ..
    '#!/usr/bin/env python3\n' ..
    '^3a6b4ce classes/database.py (misox 2019-09-25 01:16:47 +0100  3)\n')
    self.io.expectCommand("git blame moved.txt", handle)
    local expected = {
        {hash='37950820', user='mosix', date='2019-10-03', time='18:06:46', timezone='+0200'},
        {hash='^3a6b4ce', user='misox', date='2019-09-25', time='01:16:47', timezone='+0100'},
    }
    local blames = self.git.blame("moved.txt")
    for index, b in pairs(blames) do
        unit.assertEquals(b.hash, expected[index].hash)
        unit.assertEquals(b.user, expected[index].user)
        unit.assertEquals(b.date, expected[index].date)
        unit.assertEquals(b.time, expected[index].time)
        unit.assertEquals(b.timezone, expected[index].timezone)
    end
end

function TestGit:TestBlame()
    local handle = self:createHandle()
    handle:expectRead("*a", '2061a5e0 (mosix 2024-05-18 14:42:01 +0200 1) all: lint\n' ..
        '206ga5e0 (misox 2024-04-18 14:22:01 +0200 3) lint:\n' ..
        '2021a2e0 (mosix 2023-05-14 13:42:21 +0100 4)    luacheck --config .luacheckrc .\n')
    self.io.expectCommand("git blame file.txt", handle)
    local blames = self.git.blame("file.txt")
    local expected = {
        {hash='2061a5e0', user='mosix', date='2024-05-18', time='14:42:01', timezone='+0200'},
        {hash='206ga5e0', user='misox', date='2024-04-18', time='14:22:01', timezone='+0200'},
        {hash='2021a2e0', user='mosix', date='2023-05-14', time='13:42:21', timezone='+0100'},
    }
    for index, b in pairs(blames) do
        unit.assertEquals(b.hash, expected[index].hash)
        unit.assertEquals(b.user, expected[index].user)
        unit.assertEquals(b.date, expected[index].date)
        unit.assertEquals(b.time, expected[index].time)
        unit.assertEquals(b.timezone, expected[index].timezone)
    end
end

function TestGit:TestIsGitSuccess()
    local handle = self:createHandle()
    self.io.expectCommand("git blame git-file.txt 1>/dev/null 2>/dev/null; echo $?", handle)
    handle:expectRead("*a", "0\n")
    unit.assertTrue(self.git.isGit("git-file.txt"))
end


function TestGit:TestIsGitFailure()
    local handle = self:createHandle()
    self.io.expectCommand("git blame git-file.txt 1>/dev/null 2>/dev/null; echo $?", handle)
    handle:expectRead("*a", "1\n")
    unit.assertFalse(self.git.isGit("git-file.txt"))
end
-- rename isGit → canBlame
-- add test for is git
