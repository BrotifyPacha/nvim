
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

function M.winOpenFloat(buf_id)
    local options = {
        relative='editor',
        row=(vim.go.lines/3),
        col=(vim.go.columns/3),
        width=math.floor(vim.go.columns/3),
        height=math.floor(vim.go.lines/3),
        border='single',
    }
    vim.api.nvim_win_set_config(buf_id, options)
end

function M.winMoveFloat(delta_row, delta_col)
    local win_id = 0
    local current = vim.api.nvim_win_get_config(win_id)
    if current.relative == '' then
        return
    end
    local options = {
        row = current.row[false] + delta_row,
        col = current.col[false] + delta_col,
    }
    vim.api.nvim_win_set_config(win_id, vim.tbl_extend('force', current, options))
end

function M.winSelectFloat()
    for _, win_id in pairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_config(win_id).relative ~= '' then
            vim.api.nvim_set_current_win(win_id)
        end
    end
end

return M
