local unit = require('luaunit')
local Git = require '../../lua/nvim-git-blame/git'

-- mock: handle
local Handle = { out = nil }
function Handle:read(read)
    unit.assertEquals(read, "*a")
    return self.out
end
function Handle.close()
end
function Handle:setOutput(out)
    self.out = out
end

-- mock: io
local _io = { cmd = nil }
function _io.popen(cmd, mode)
    unit.assertEquals(cmd, _io.cmd)
    unit.assertEquals('r', mode)
    return Handle
end
Git.setIO(_io)

TestGit = {}

function TestGit.TestBlame()
    _io.cmd = "git blame file.txt"
    Handle:setOutput('2061a5e0 (mosix 2024-05-18 14:42:01 +0200 1) all: lint\n' ..
        '206ga5e0 (misox 2024-04-18 14:22:01 +0200 3) lint:\n' ..
        '2021a2e0 (mosix 2023-05-14 13:42:21 +0100 4)    luacheck --config .luacheckrc .\n')
    local blames = Git.blame("file.txt")
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

function TestGit.TestBlameMovedFile()
    _io.cmd = "git blame moved.txt"
    Handle:setOutput('37950820 classes/database.py (mosix 2019-10-03 18:06:46 +0200  1) #!/usr/bin/env python3\n' ..
        '^3a6b4ce classes/database.py (misox 2019-09-25 01:16:47 +0100  3)\n')
    local blames = Git.blame("moved.txt")
    local expected = {
        {hash='37950820', user='mosix', date='2019-10-03', time='18:06:46', timezone='+0200'},
        {hash='^3a6b4ce', user='misox', date='2019-09-25', time='01:16:47', timezone='+0100'},
    }
    for index, b in pairs(blames) do
        unit.assertEquals(b.hash, expected[index].hash)
        unit.assertEquals(b.user, expected[index].user)
        unit.assertEquals(b.date, expected[index].date)
        unit.assertEquals(b.time, expected[index].time)
        unit.assertEquals(b.timezone, expected[index].timezone)
    end
end

function TestGit.TestIsGit()
    _io.cmd = "git status 1>/dev/null 2>/dev/null; echo $?"
    Handle:setOutput("0\n")
    unit.assertTrue(Git.isGit())
    Handle:setOutput("1\n")
    unit.assertFalse(Git.isGit())
end

function TestGit.TestIsFile()
    _io.cmd = "head file.txt 1>/dev/null 2>/dev/null; echo $?"
    Handle:setOutput("0\n")
    unit.assertTrue(Git.isFile("file.txt"))
    Handle:setOutput("1\n")
    unit.assertFalse(Git.isFile("file.txt"))
end

