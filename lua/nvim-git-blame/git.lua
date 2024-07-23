local Git = { _io = io }

-- return { hash, user, date, time, timezone }
function Git.blame(filename)
    local handle = Git._io.popen('git blame ' .. filename, 'r')
    local output = handle:read('*a')
    handle:close()
    local blames = {}
    for line in output:gmatch('([^\n]+)\n?') do
        local hash, user, date, time, timezone = line:match('^(%S+)%s.-%((.-)%s([-%d]-)%s(%d-:%d-:%d-)%s(.-)%s')
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

function Git.isGit()
    local handle = Git._io.popen('git status 1>/dev/null 2>/dev/null; echo $?', 'r')
    local output = handle:read('*a')
    handle:close()
    if '0\n' == output then
        return true
    end
    return false
end

function Git.isFile(filepath)
    local handle = Git._io.popen('head ' .. filepath .. ' 1>/dev/null 2>/dev/null; echo $?', 'r')
    local output = handle:read('*a')
    handle:close()
    if '0\n' == output then
        return true
    end
    return false
end

if _G._TEST then
    function Git.setIO(new)
        Git._io = new
    end
end

return Git

