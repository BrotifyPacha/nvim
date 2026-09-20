-- Reads reusable debug profiles (arg/env presets) for the <leader>da picker.
--
-- Native format, ./.nvim/dap-profiles.json:
--   {
--     "profiles": [
--       {
--         "name": "with verbose flag",   -- optional, for your own reference
--         "filetype": "go",              -- optional, matches vim.bo.filetype; omit to show for any filetype
--         "config": "Debug go entrypoint", -- optional, matches dap.configurations[ft][].name; omit to show for any config
--         "args": ["--verbose", "--port=9000"],
--         "env": { "FOO": "bar" }
--       }
--     ]
--   }
--
-- Also understands VSCode's ./.vscode/launch.json (JSONC), reading each
-- configuration's `args`/`env` as a profile scoped to its `type`/`name`.

local M = {}

local vscode_type_to_filetype = {
    go = 'go',
    delve = 'go',
    php = 'php',
    python = 'python',
    debugpy = 'python',
}

local function read_file(path)
    if vim.fn.filereadable(path) == 0 then
        return nil
    end
    local fd = io.open(path, 'r')
    if not fd then
        return nil
    end
    local content = fd:read('*a')
    fd:close()
    return content
end

local function decode_json(path, content)
    local ok, decoded = pcall(vim.json.decode, content)
    if not ok then
        vim.notify('dap-profiles: failed to parse ' .. path .. ': ' .. tostring(decoded), vim.log.levels.WARN)
        return nil
    end
    return decoded
end

-- Naive comment stripper, good enough for launch.json's // and /* */ comments.
local function strip_jsonc_comments(content)
    content = content:gsub('/%*.-%*/', '')
    content = content:gsub('//[^\n]*', '')
    return content
end

function M.load_native_profiles()
    local path = vim.fn.getcwd() .. '/.nvim/dap-profiles.json'
    local content = read_file(path)
    if content == nil then
        return {}
    end
    local decoded = decode_json(path, content)
    if decoded == nil or decoded.profiles == nil then
        return {}
    end
    return decoded.profiles
end

function M.load_vscode_profiles()
    local path = vim.fn.getcwd() .. '/.vscode/launch.json'
    local content = read_file(path)
    if content == nil then
        return {}
    end
    local decoded = decode_json(path, strip_jsonc_comments(content))
    if decoded == nil or decoded.configurations == nil then
        return {}
    end
    local profiles = {}
    for _, cfg in ipairs(decoded.configurations) do
        -- Scoped by filetype only (not `config`): a vscode launch config's
        -- name essentially never matches a dap.configurations[].name here,
        -- so scoping by config would make these candidates unreachable.
        table.insert(profiles, {
            name = cfg.name,
            filetype = vscode_type_to_filetype[cfg.type] or cfg.type,
            args = cfg.args or {},
            env = cfg.env or {},
        })
    end
    return profiles
end

-- Returns profiles applicable to the given filetype/config name.
function M.get_profiles(filetype, config_name)
    local all = {}
    vim.list_extend(all, M.load_native_profiles())
    vim.list_extend(all, M.load_vscode_profiles())

    local matched = {}
    for _, profile in ipairs(all) do
        local filetype_ok = profile.filetype == nil or profile.filetype == filetype
        local config_ok = profile.config == nil or profile.config == config_name
        if filetype_ok and config_ok then
            table.insert(matched, profile)
        end
    end
    return matched
end

return M
