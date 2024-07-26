local unit = require 'luaunit'

local IO = {
    expectedCommands = {},
}

function IO.countTable(table)
  local count = 0
  for _ in pairs(table) do
      count = count + 1
  end
  return count
end

function IO.tearDown()
    unit.assertEquals(IO.countTable(IO.expectedCommands), 0)
end

function IO.expectCommand(cmd, willReturn)
    table.insert(IO.expectedCommands, {cmd, willReturn})
end

function IO.popen(cmd, mode)
    unit.assertEquals(mode, "r")
    unit.assertEquals(cmd, IO.expectedCommands[1][1])
    local willReturn = IO.expectedCommands[1][2]
    table.remove(IO.expectedCommands, 1)
    return willReturn
end

return IO
