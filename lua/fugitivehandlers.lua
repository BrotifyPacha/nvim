
local M = {}

local function handleGitlab(opts)
    local file_url = opts.remote .. '/-/blob/' .. opts.commit .. '/' .. opts.path
    return file_url .. "#L" .. opts.line1 .. '-' .. opts.line2
end

local function handleGithub(opts)
    local file_url = opts.remote .. '/blob/' .. opts.commit .. '/' .. opts.path
    return file_url .. "#L" .. opts.line1 .. '-L' .. opts.line2
end

function M.CustomGBrowseHandler(opts)
    opts.remote = 'https://' .. opts.remote
        :gsub('^ssh://git@', '')
        :gsub('^git@', '')
        :gsub('^ssh.', '')
        :gsub(':', '/')
        :gsub('.git$', '')
    if string.find(opts.remote, 'gitlab.', 0, true) then
        return handleGitlab(opts)
    end
    if string.find(opts.remote, 'github.', 0, true) then
        return handleGithub(opts)
    end
end

return M
