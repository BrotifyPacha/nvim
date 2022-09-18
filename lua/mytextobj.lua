local M = {}

local function findFromEnd(str, pattern)
    local s = str:reverse():find(pattern)
    if s == nil then return nil end
    return str:len() - s + 1
end

local function updateVisualSelection(buf, startPos, endPos, linewise)
    linewise = linewise or false
    if linewise then
        vim.api.nvim_exec("normal! V", false)
    else
        vim.api.nvim_exec("normal! v", false)
    end
    vim.api.nvim_win_set_cursor(buf, startPos)
    vim.api.nvim_exec("normal! o", false)
    vim.api.nvim_win_set_cursor(buf, endPos)
end

function M.indentTextObj()
    local initPos = vim.api.nvim_win_get_cursor(0)
    local currLine = vim.api.nvim_get_current_line()
    local indentLevel = tonumber((currLine:find('[^%s]') or 1) - 1)

    if indentLevel == 0 then return M.documentTextObj() end

    local currLN = initPos[1]
    local startLN = nil
    local endLN = nil
    while true do
        local line = vim.api.nvim_buf_get_lines(0, currLN-2, currLN-1, false)[1]
        local currIndentLevel = tonumber((line:find('[^%s]') or 1) - 1)
        if line:match('^$') ~= nil then goto continue1 end
        if currIndentLevel < indentLevel then
            startLN = currLN
            break
        end
        ::continue1::
        currLN = currLN - 1
    end
    currLN = initPos[1]
    while true do
        local line = vim.api.nvim_buf_get_lines(0, currLN, currLN+1, false)[1]
        local currIndentLevel = tonumber((line:find('[^%s]') or 1) - 1)
        if line:match('^$') ~= nil then goto continue2 end
        if currIndentLevel < indentLevel then
            endLN = currLN
            break
        end
        ::continue2::
        currLN = currLN + 1
    end
    updateVisualSelection(0, {startLN, 0}, {endLN, 0}, true)
end

-- selects whole document
function M.documentTextObj()
    local startSel = {1, 0}
    local endSel = { vim.api.nvim_buf_line_count(0), 0 }
    updateVisualSelection(0, startSel, endSel, true)
end

return M
