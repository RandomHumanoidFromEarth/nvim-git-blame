local unit = require 'luaunit'

local Handle = {}

function Handle:new(p)
    local o = p or {}
    setmetatable(o, { __index = self  })
    o.expected_reads = {}
    o.is_closed = false
    return o
end

function Handle.countTable(table)
  local count = 0
  for _ in pairs(table) do
      count = count + 1
  end
  return count
end

function Handle:tearDown()
    unit.assertEquals(self.countTable(self.expected_reads), 0)
    unit.assertTrue(self.is_closed)
end

function Handle:expectRead(read, willReturn)
    table.insert(self.expected_reads, {read, willReturn})
end

function Handle:read(read)
    unit.assertEquals(read, self.expected_reads[1][1])
    local willReturn = self.expected_reads[1][2]
    table.remove(self.expected_reads, 1)
    return willReturn
end

function Handle:close()
    self.is_closed = true
end

return Handle
