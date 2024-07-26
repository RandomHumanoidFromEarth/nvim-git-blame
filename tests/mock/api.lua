local unit = require 'luaunit'
local Api = {
    asserts = {
        set_cursor = {},
        get_cursor = {},
        buf_setlines = {},
        buf_getlines = {},
        buf_create = {},
        win_get = {},
        win_set = {},
        win_getwidth = {},
        win_setwidth = {},
        list_wins = {},
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
    unit.assertEquals(0, Api.countTable(Api.asserts.buf_create))
    unit.assertEquals(0, Api.countTable(Api.asserts.win_get))
    unit.assertEquals(0, Api.countTable(Api.asserts.win_set))
    unit.assertEquals(0, Api.countTable(Api.asserts.win_getwidth))
    unit.assertEquals(0, Api.countTable(Api.asserts.win_setwidth))
    unit.assertEquals(0, Api.countTable(Api.asserts.list_wins))
    Api.asserts = {
        set_cursor = {},
        get_cursor = {},
        buf_setlines = {},
        buf_getlines = {},
        buf_create = {},
        win_get = {},
        win_set = {},
        win_getwidth = {},
        win_setwidth = {},
        cmd = {},
        list_wins = {},
    }
end

function Api.expectSetCursor(win, pos)
    table.insert(Api.asserts.set_cursor, {win, pos})
end

function Api.nvim_win_set_cursor(win, pos)
    unit.assertEquals(Api.asserts.set_cursor[1], win)
    unit.assertEquals(Api.asserts.set_cursor[2][1], pos[1])
    unit.assertEquals(Api.asserts.set_cursor[2][1], pos[2])
    table.remove(Api.asserts.set_cursor, 1)
end

function Api.expectGetCursor(win, willReturn)
    table.insert(Api.asserts.get_cursor, {win, willReturn})
end

function Api.nvim_win_get_cursor(win)
    unit.assertEquals(Api.asserts.get_cursor[1][1], win)
    local willReturn = Api.asserts.get_cursor[1][2]
    table.remove(Api.asserts.get_cursor, 1)
    return willReturn
end

function Api.expectBufSetLines(buf, from, to, strict_indexing, replace)
    table.insert(Api.asserts.buf_setlines, {buf, from, to, strict_indexing, replace})
end

function Api.nvim_buf_set_lines(buf, from, to, strict_indexing, replace)
    unit.assertEquals(buf, Api.asserts.buf_setlines[1][1])
    unit.assertEquals(from, Api.asserts.buf_setlines[1][2])
    unit.assertEquals(to, Api.asserts.buf_setlines[1][3])
    unit.assertEquals(strict_indexing, Api.asserts.buf_setlines[1][4])
    unit.assertEquals(replace, Api.asserts.buf_setlines[1][5])
    table.remove(Api.asserts.buf_setlines, 1)
end

function Api.expectBufGetLines(buf, from, to, strict_indexing, willReturn)
    table.insert(Api.asserts.buf_getlines, {buf, from, to, strict_indexing, willReturn})
end

function Api.nvim_buf_get_lines(buf, from, to, strict_indexing)
    unit.assertEquals(buf, Api.asserts.buf_getlines[1][1])
    unit.assertEquals(from, Api.asserts.buf_getlines[1][2])
    unit.assertEquals(to, Api.asserts.buf_getlines[1][3])
    unit.assertEquals(strict_indexing, Api.asserts.buf_getlines[1][4])
    local willReturn = Api.asserts.buf_getlines[1][5]
    table.remove(Api.asserts.buf_getlines, 1)
    return willReturn
end

function Api.expectBufCreate(listed, scratch, willReturn)
    table.insert(Api.asserts.buf_create, {listed, scratch, willReturn})
end

function Api.nvim_create_buf(listed, scratch)
    unit.assertEquals(Api.asserts.buf_create[1][1], listed)
    unit.assertEquals(Api.asserts.buf_create[1][2], scratch)
    local willReturn = Api.asserts.buf_create[1][3]
    table.remove(Api.asserts.buf_create, 1)
    return willReturn
end

function Api.expectWinGetCurrent(willReturn)
    table.insert(Api.asserts.win_get, willReturn)
end

function Api.nvim_get_current_win()
    local win = Api.asserts.win_get[1]
    table.remove(Api.asserts.win_get, 1)
    return win
end

function Api.expectWinSetCurrent(win)
    table.insert(Api.asserts.win_set, win)
end

function Api.nvim_set_current_win(win)
    unit.assertEquals(Api.asserts.win_set[1], win)
    table.remove(Api.asserts.win_set, 1)
end

function Api.expectWinGetWidth(win, willReturn)
    table.insert(Api.asserts.win_getwidth, {win, willReturn})
end

function Api.nvim_win_get_width(win)
    unit.assertEquals(Api.asserts.win_getwidth[1][1], win)
    local willReturn = Api.asserts.win_getwidth[1][2]
    table.remove(Api.asserts.win_getwidth, 1)
    return willReturn
end

function Api.expectWinSetWidth(win, width)
    table.insert(Api.asserts.win_setwidth, {win, width})
end

function Api.nvim_win_set_width(win, width)
    unit.assertEquals(Api.asserts.win_setwidth[1][1], win)
    unit.assertEquals(Api.asserts.win_setwidth[1][2], width)
    table.remove(Api.asserts.win_setwidth, 1)
end

function Api.expectListWins(willReturn)
    table.insert(Api.asserts.list_wins, willReturn)
end

function Api.nvim_list_wins()
    local willReturn = Api.asserts.list_wins[1];
    table.remove(Api.asserts.list_wins, 1)
    return willReturn
end

return Api
