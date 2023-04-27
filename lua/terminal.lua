local m = {}

vim.api.nvim_create_autocmd('BufWinEnter', {
    pattern = '*',
    callback = function ()
        local terminals = m.get_terminals()
        local curr_buf_id = vim.api.nvim_get_current_buf()
        if not vim.tbl_contains(terminals, curr_buf_id) then
            local win_id = vim.fn.bufwinid(curr_buf_id)
            local set_win_option = vim.api.nvim_win_set_option
            set_win_option(win_id, "number", true)
            set_win_option(win_id, "numberwidth", 4)
            set_win_option(win_id, "signcolumn", 'auto:2-9')
        end
    end,
})

function m.set_terminals(terminals)
    vim.g.terminal_buf_ids = terminals
end

function m.get_terminals()
    local terminals = vim.g.terminal_buf_ids
    if terminals == nil then
        terminals = {}
    end
    return terminals
end

local function new_terminal()
    vim.cmd "terminal"
    vim.fn.feedkeys("a")
    return vim.api.nvim_get_current_buf()
end

local function set_default_settings(terminal_buf_id)
    local win_id = vim.fn.bufwinid(terminal_buf_id)

    local set_win_option = vim.api.nvim_win_set_option

    set_win_option(win_id, "number", false)
    set_win_option(win_id, "numberwidth", 4)
    set_win_option(win_id, "signcolumn", 'yes:1')
end

function m.open_terminal()
    local terminals = m.get_terminals()
    -- remove invalid buf_ids
    local valid_terminals = {}
    for _, terminal in ipairs(terminals) do
        if vim.api.nvim_buf_is_valid(terminal) then
            valid_terminals[#valid_terminals+1] = terminal
        end
    end
    terminals = valid_terminals

    if #terminals == 0 then
        local new_term = new_terminal()
        set_default_settings(new_term)
        m.set_terminals({ new_term })
        return
    end

    local current_buf_id = vim.api.nvim_get_current_buf()
    if not vim.tbl_contains(terminals, current_buf_id) then
        vim.api.nvim_win_set_buf(0, terminals[1])
        return
    end

    local open_terminal_index = -1
    for i, terminal in ipairs(terminals) do
        if terminal == current_buf_id then
            open_terminal_index = i - 1
            break
        end
    end
    local next_terminal_index = (open_terminal_index + 1) % #terminals + 1
    vim.api.nvim_win_set_buf(0, terminals[next_terminal_index])

    m.set_terminals(terminals)
end

function m.open_new_terminal()
    local new_term = new_terminal()
    set_default_settings(new_term)
    local terminals = m.get_terminals()
    terminals[#terminals+1] = new_term
    m.set_terminals(terminals)
end

return m
