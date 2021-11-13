local M = {}

-- selects multi-line expression
-- text = expression(
    -- startExr() 
-- );
-- { text : expression };
function M.expressionTextObj()
    local initPos = vim.api.nvim_win_get_cursor(0)
    local currLine = vim.api.nvim_get_current_line()

    local s, e = string.find(currLine, '[=:]')
    if s == nil then return end

    local sym = string.sub(currLine, s, s)
    local s, e = string.find(currLine, '[^' .. sym .. '%s]', s)
    if s == nil then return end

    local expStart = { initPos[1], s - 1 }

    local s, e = string.find(currLine, '[({[]', s)
    if s ~= nil then
        local bracketPos = { initPos[1], s - 1 }
        vim.api.nvim_win_set_cursor(0, bracketPos)
        vim.api.nvim_command('normal! %')
    end

    local newPos = vim.api.nvim_win_get_cursor(0)
    local currLine = vim.api.nvim_get_current_line()
    local s, e = string.find(currLine, '[^;}%s$]', newPos[2] + 1 + 1)

    if s ~= nil then
        local expEnd = { newPos[1], s - 1 }
    end
    local expEnd = newPos

    updateVisualSelection(0, expStart, expEnd)
end

-- selects whole document
function M.documentTextObj()
    local startSel = {1, 0}
    local endSel = { vim.api.nvim_buf_line_count(0), 0 }
    updateVisualSelection(0, startSel, endSel, true)
end

local function updateVisualSelection(buf, startPos, endPos, linewise)
    local linewise = linewise or false
    vim.api.nvim_win_set_cursor(buf, startPos)
    if linewise then
        vim.api.nvim_exec("normal! V", false)
    else
        vim.api.nvim_exec("normal! v", false)
    end
    vim.api.nvim_win_set_cursor(buf, endPos)
end

return M
