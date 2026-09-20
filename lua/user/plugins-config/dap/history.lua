-- Persists recently used args/env combos per project+config so the
-- <leader>da picker has candidates beyond what's in dap-profiles.json.

local M = {}

local function history_path()
    return vim.fn.stdpath('data') .. '/dap-history.json'
end

local function history_key(config_name)
    return vim.fn.getcwd() .. '::' .. config_name
end

local function read_all()
    local path = history_path()
    if vim.fn.filereadable(path) == 0 then
        return {}
    end
    local fd = io.open(path, 'r')
    if not fd then
        return {}
    end
    local content = fd:read('*a')
    fd:close()
    local ok, decoded = pcall(vim.json.decode, content)
    if not ok or type(decoded) ~= 'table' then
        return {}
    end
    return decoded
end

local function write_all(data)
    local fd = io.open(history_path(), 'w')
    if not fd then
        return
    end
    fd:write(vim.json.encode(data))
    fd:close()
end

-- Returns (args, env) string lists previously used for this config in this project.
function M.get(config_name)
    local entry = read_all()[history_key(config_name)] or {}
    return entry.args or {}, entry.env or {}
end

-- args: list of strings. env: list of "KEY=VALUE" strings.
function M.remember(config_name, args, env)
    local all = read_all()
    local key = history_key(config_name)
    local entry = all[key] or { args = {}, env = {} }

    for _, value in ipairs(args) do
        if not vim.tbl_contains(entry.args, value) then
            table.insert(entry.args, value)
        end
    end
    for _, value in ipairs(env) do
        if not vim.tbl_contains(entry.env, value) then
            table.insert(entry.env, value)
        end
    end

    all[key] = entry
    write_all(all)
end

return M
