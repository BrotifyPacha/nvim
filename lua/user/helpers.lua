
local M = {}

function M.reload(m)
    package.loaded[m] = nil
    require(m)
end

function M.visualExec(func)
    if vim.fn.mode() ~= 'v' or vim.fn.mode() ~= 'V' then
        vim.api.nvim_exec([[
            normal! gv
            lua ]] .. func
        , false)
    end
end

function M.getRemoteLink()
    local handle = io.popen('git remote -v | head -n 1 | awk \'{print $2}\' | sed s/\\r$// ')
    local remote = handle:read("*a")
    handle:close()
    remote = string.gsub(remote, '^http://', '')
    remote = string.gsub(remote, '^https://', '')
    remote = string.gsub(remote, '^ssh://', '')
    remote = string.gsub(remote, 'git@', '')
    remote = string.gsub(remote, 'ssh%.', '')
    remote = string.gsub(remote, '%.git', '')
    remote = string.gsub(remote, ':', '/')
    return 'http://' .. remote
end

function M.xdgOpen(arg)
    os.execute('xdg-open "' .. arg .. '"')
end

return M
