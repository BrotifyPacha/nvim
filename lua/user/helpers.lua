
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

function M.getMyWinbar()
    local fname = vim.fn.expand('%:t')
    if fname == '' then
        fname = '%#Comment#-No-name-%*'
    end
    local devicons, err = require'nvim-web-devicons'
    local icon = nil
    local highlight = nil
    if err == nil then
        icon, highlight = devicons.get_icon_by_filetype(vim.bo.ft)
        icon = '%#' .. highlight .. '#' .. icon .. '%*'
    end

    local sep = ' %#Comment#%*%< '
    local class_highlight     = '%#Type#'
    local container_highlight = class_highlight
    local method_highlight    = '%#Function#'
    local function_highlight  = '%#Special#'

    local sequence_highlight  = class_highlight
    local mapping_highlight   = function_highlight
    local stiring_highlight   = '%#String#'

    local gps = require'nvim-gps'
    local gps_data_func = gps.get_data
    local _, gps_data = pcall(gps_data_func)
    local output = { icon .. ' ' .. fname }
    if gps ~= nil and gps_data ~= nil and gps.is_available() then
        for _, item in pairs(gps_data) do
            local highlight = nil
            if item.type == 'class-name' then
                highlight = class_highlight
            elseif item.type == 'container-name' then
                highlight = container_highlight
            elseif item.type == 'method-name' then
                highlight = method_highlight
            elseif item.type == 'function-name' then
                highlight = function_highlight
            elseif item.type == 'sequence-name' then
                highlight = sequence_highlight
            elseif item.type == 'mapping-name' then
                highlight = mapping_highlight
            elseif item.type == 'string-name' then
                highlight = stiring_highlight
            else
                highlight = '%#Normal#'
            end
            table.insert(
                output,
                highlight .. item.icon .. '%*' .. '%#Folded#' .. item.text .. '%*'
            )
        end
    end
    return "  " .. table.concat(output, sep)
end

return M
