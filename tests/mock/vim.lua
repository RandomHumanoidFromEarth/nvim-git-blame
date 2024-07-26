local unit = require 'luaunit'
local Vim = {
    api = require '../../tests/mock/api',
    asserts = {
        cmd = {}
    },
}

function Vim.tearDown()
    Vim.api.tearDown()
    unit.assertEquals(Vim.count(Vim.asserts.cmd), 0)
    Vim.asserts = {
        cmd = {},
    }
end

function Vim.count(table)
    local count = 0
    for _ in pairs(table) do
        count = count + 1
    end
    return count
end

function Vim.expectCmd(cmd)
    table.insert(Vim.asserts.cmd, cmd)
end

function Vim.cmd(cmd)
    unit.assertEquals(Vim.asserts.cmd[1], cmd)
    table.remove(Vim.asserts.cmd, 1)
end

return Vim
