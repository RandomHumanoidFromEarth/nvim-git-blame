local M = {}

local function blame(filename)
    local handle = io.popen("git blame " .. filename, "r")
    local output = handle:read("*a")
    handle:close()
    return output
end

local function parse(output)
    local index = 0
    local blames = {}
    for line in output:gmatch("([^\n]*)\n?") do
        local hash, user, date, time, timezone = line:match("^(%S+)%s.(.-)%s([-%d]-)%s(%d-:%d-:%d-)%s(.-)%s")
        if nil == hash then
            break
        end
        local commit = {
            hash = hash,
            user = user,
            date = date,
            time = time,
            timezone = timezone
        }
        blames[index] = commit
        index = index+1;
    end
    return blames
end

-- return { hash, user, date, time, timezone }
function M.blame(filepath)
    local out = blame(filepath)
    return parse(out)
end

return M


