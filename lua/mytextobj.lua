local M = {}

local function findFromEnd(str, pattern)
    local s = str:reverse():find(pattern)
    if s == nil then return nil end
    return str:len() - s + 1
end

local function updateVisualSelection(buf, startPos, endPos, linewise)
    linewise = linewise or false
    vim.api.nvim_win_set_cursor(buf, startPos)
    if linewise then
        vim.api.nvim_exec("normal! V", false)
    else
        vim.api.nvim_exec("normal! v", false)
    end
    vim.api.nvim_win_set_cursor(buf, endPos)
end

-- selects multi-line expression
-- text = expression(
    -- startExr()
-- );
-- { text : expression };
function M.expressionTextObj()
    local initPos = vim.api.nvim_win_get_cursor(0)
    local currLine = vim.api.nvim_get_current_line()

    -- find separator : or =
    local expSep = string.find(currLine, '[=:]')
    if expSep == nil then return end

    -- detect what separator found
    local sym = string.sub(currLine, expSep, expSep)
    local s = string.find(currLine, '[^' .. sym .. '%s]', expSep)
    if s == nil then return end

    -- mark expression start
    local expStart = { initPos[1], s - 1 }

    -- find any sort of a bracket from the end and jump using %
    s = findFromEnd(currLine, '[({[]')
    if s ~= nil then
        local bracketPos = { initPos[1], s - 1 }
        vim.api.nvim_win_set_cursor(0, bracketPos)
        vim.api.nvim_command('normal! %')
    end

    -- go to end of the line
    vim.api.nvim_command('normal! $')
    local newPos = vim.api.nvim_win_get_cursor(0)
    currLine = vim.api.nvim_get_current_line()

    s = nil
    if sym == '=' then
        s = findFromEnd(currLine, '[^;%s]')
    elseif sym == ':' then
        s = findFromEnd(currLine, '[^,%s]')
    end

    local expEnd = {}
    if s ~= nil then
        expEnd = { newPos[1], s - 1 }
    else
        expEnd = newPos
    end

    updateVisualSelection(0, expStart, expEnd)
end

-- selects whole document
function M.documentTextObj()
    local startSel = {1, 0}
    local endSel = { vim.api.nvim_buf_line_count(0), 0 }
    updateVisualSelection(0, startSel, endSel, true)
end

return M
