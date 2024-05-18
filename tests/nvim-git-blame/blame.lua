local test = require('luaunit')

TestBlame = {}

function TestBlame:setUp()
    self.blame = require '../../lua/nvim-git-blame/blame'
end

function TestBlame:testParse()
    local out_regular = '' ..
    '2061a5e0 (mosix 2024-05-18 14:42:01 +0200 1) all: lint\n' ..
    '206ga5e0 (misox 2024-04-18 14:22:01 +0200 3) lint:\n' ..
    '2021a2e0 (mosix 2023-05-14 13:42:21 +0100 4)    luacheck --config .luacheckrc .\n'
    local expected = {
        {hash='2061a5e0', user='mosix', date='2024-05-18', time='14:42:01', timezone='+0200'},
        {hash='206ga5e0', user='misox', date='2024-04-18', time='14:22:01', timezone='+0200'},
        {hash='2021a2e0', user='mosix', date='2023-05-14', time='13:42:21', timezone='+0100'},
    }
    local blames = self.blame._parse(out_regular)
    local expected_index = 1 -- wtf ... lua starts at index 1
    for _, b in pairs(blames) do
        test.assertEquals(b.hash, expected[expected_index].hash)
        test.assertEquals(b.user, expected[expected_index].user)
        test.assertEquals(b.date, expected[expected_index].date)
        test.assertEquals(b.time, expected[expected_index].time)
        test.assertEquals(b.timezone, expected[expected_index].timezone)
        expected_index = expected_index + 1
    end
end

function TestBlame:testMovedFile()
    local out_moved = '' ..
    '37950820 classes/database.py (mosix 2019-10-03 18:06:46 +0200  1) #!/usr/bin/env python3\n' ..
    '^3a6b4ce classes/database.py (misox 2019-09-25 01:16:47 +0100  3)\n'
    local expected = {
        {hash='37950820', user='mosix', date='2019-10-03', time='18:06:46', timezone='+0200'},
        {hash='^3a6b4ce', user='misox', date='2019-09-25', time='01:16:47', timezone='+0100'},
    }
    local blames = self.blame._parse(out_moved)
    local expected_index = 1 -- wtf ... lua starts at index 1
    for _, b in pairs(blames) do
        test.assertEquals(b.hash, expected[expected_index].hash)
        test.assertEquals(b.user, expected[expected_index].user)
        test.assertEquals(b.date, expected[expected_index].date)
        test.assertEquals(b.time, expected[expected_index].time)
        test.assertEquals(b.timezone, expected[expected_index].timezone)
        expected_index = expected_index + 1
    end
end

