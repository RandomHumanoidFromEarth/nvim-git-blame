_G._TEST = true

-- search *.lua files
local handle = io.popen('find tests/nvim-git-blame -type f -name "*.lua"')
local out = handle:read('*a')
handle:close()

-- require test modules
for file in out:gmatch('([^\n]+)\n?') do
    local module = string.sub(file, 0, -5)
    if 'tests/init' ~= module then
        require(module)
    end
end

-- run suite
local luaunit = require('luaunit')
local suite = luaunit.LuaUnit.new()
suite:setOutputType('TAP')
os.exit(suite:runSuite())
