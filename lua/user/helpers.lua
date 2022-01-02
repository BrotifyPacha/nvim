
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

return M
