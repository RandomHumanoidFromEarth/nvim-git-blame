local Blame = {}

local function blame(filename)
    local handle = io.popen("git blame " .. filename, "r")
    local output = handle:read("*a")
    handle:close()
    return output
end

local function parse(output)
    local blames = {}
    for line in output:gmatch("([^\n]+)\n?") do
        local hash, user, date, time, timezone = line:match("^(%S+)%s.-%((.-)%s([-%d]-)%s(%d-:%d-:%d-)%s(.-)%s")
        local commit = {}
        commit.hash = hash
        commit.user = user
        commit.date = date
        commit.time = time
        commit.timezone = timezone
        table.insert(blames, commit)
    end
    return blames
end

-- return { hash, user, date, time, timezone }
function Blame.blame(filepath)
    local out = blame(filepath)
    return parse(out)
end

if _G._TEST then
    Blame._parse = parse
end

return Blame


