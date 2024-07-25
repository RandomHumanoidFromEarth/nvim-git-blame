local unit = require 'luaunit'
local Api = {
    asserts = {
        set_cursor = {},
        get_cursor = {},
        buf_setlines = {},
        buf_getlines = {},
        win_get = {},
        win_set = {},
    }
}

function Api.countTable(table)
  local count = 0
  for _ in pairs(table) do
      count = count + 1
  end
  return count
end


function Api.tearDown()
    unit.assertEquals(0, Api.countTable(Api.asserts.set_cursor))
    unit.assertEquals(0, Api.countTable(Api.asserts.get_cursor))
    unit.assertEquals(0, Api.countTable(Api.asserts.buf_setlines))
    unit.assertEquals(0, Api.countTable(Api.asserts.buf_getlines))
    unit.assertEquals(0, Api.countTable(Api.asserts.win_get))
    unit.assertEquals(0, Api.countTable(Api.asserts.win_set))
    Api.asserts = {
        set_cursor = {},
        get_cursor = {},
        buf_setlines = {},
        buf_getlines = {},
        win_get = {},
        win_set = {},
    }
end

function Api.nvim_set_cursor(win, pos)
    unit.assertEquals(Api.asserts.set_cursor[1], win)
    unit.assertEquals(Api.asserts.set_cursor[2], pos[1])
    unit.assertEquals(Api.asserts.set_cursor[3], pos[2])
    table.remove(Api.asserts.set_cursor, 1)
end

function Api.expectGetCursor(win, willReturn)
    table.insert(Api.asserts.getcursor, {win=win, willReturn=willReturn})
end

function Api.nvim_get_cursor(win)
    unit.assertEquals(Api.asserts.get_cursor[1].win, win)
    local willReturn = Api.asserts.get_cursor[1].willReturn
    table.remove(Api.asserts.get_cursor, 1)
    return willReturn
end

function Api.expectBufSetLines(buf, from, to, strict_indexing, replace)
    table.insert(Api.asserts.buf_setlines, {buf, from, to, strict_indexing, replace})
end

function Api.nvim_buf_set_lines(buf, from, to, strict_indexing, replace)
    unit.assertEquals(Api.asserts.buf_setlines[1][1], buf)
    unit.assertEquals(Api.asserts.buf_setlines[1][2], from)
    unit.assertEquals(Api.asserts.buf_setlines[1][3], to)
    unit.assertEquals(Api.asserts.buf_setlines[1][4], strict_indexing)
    unit.assertEquals(Api.asserts.buf_setlines[1][5], replace)
    table.remove(Api.asserts.buf_setlines, 1)
end

function Api.expectBufGetLines(buf, from, to, strict_indexing, replace)
    table.insert(Api.asserts.buf_getlines, {buf, from, to, strict_indexing, replace})
end

function Api.nvim_buf_set_lines(buf, from, to, strict_indexing, replace)
    unit.assertEquals(Api.asserts.buf_getlines[1][1], buf)
    unit.assertEquals(Api.asserts.buf_getlines[1][2], from)
    unit.assertEquals(Api.asserts.buf_getlines[1][3], to)
    unit.assertEquals(Api.asserts.buf_getlines[1][4], strict_indexing)
    unit.assertEquals(Api.asserts.buf_getlines[1][5], replace)
    table.remove(Api.asserts.buf_getlines, 1)
end

function Api.expectGetCurrentWin(willReturn)
    table.insert(Api.asserts.win_get, willReturn)
end

function Api.nvim_get_current_win()
    local win = Api.asserts.win_get[1]
    table.remove(Api.asserts.win_get, 1)
    return win
end

function Api.expectSetCurrentWin(win)
    table.insert(Api.asserts.win_set, win)
end

function Api.nvim_set_current_win(win)
    unit.assertEquals(Api.asserts.win_set[1], win)
    table.remove(Api.asserts.win_set, 1)
end

return Api
