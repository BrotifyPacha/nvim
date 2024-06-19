local M = {}

local function findFromEnd(str, pattern)
    local s = str:reverse():find(pattern)
    if s == nil then return nil end
    return str:len() - s + 1
end


function M.updateVisualSelection(buf, startPos, endPos, linewise)
    print("start ", startPos, " end ", endPos)
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

local updateVisualSelection = M.updateVisualSelection

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

-- helloWorldThiisIsAss
function M.camelCaseTextObj()
    local pos = vim.fn.getpos(".")
    local startSel = { pos[2], pos[3] }
    local endSel = { startSel[1], startSel[2] }

    local line = vim.api.nvim_get_current_line()

    local idx = 0
    while true do
        local left_symbol = line:sub(startSel[2], startSel[2])

        -- print(idx, " ", left_symbol)

        if idx == 0 and left_symbol:match("%u") then
            break
        end

        if left_symbol:match("[%l%d_]") == nil then
            if left_symbol:match("%a") == nil then
                startSel[2] = startSel[2] + 1
            end
            --startSel[2] = startSel[2] + 1
            break
        end

        startSel[2] = startSel[2] - 1
        idx = idx + 1
        if idx > 20 then
            print("left is bad")
            break
        end
    end

    idx = 0
    while true do
        local right_symbol = line:sub(endSel[2], endSel[2])

        -- print(idx, " ", right_symbol)
        if idx == 0 and right_symbol:match("%u") ~= nil then
            endSel[2] = endSel[2] + 1
            goto continue
        end

        if right_symbol:match("[%l%d_]") == nil then
            endSel[2] = endSel[2] - 1
            break
        end

        endSel[2] = endSel[2] + 1

        idx = idx + 1
        if idx > 20 then
            print("right is bad")
            break
        end

        ::continue::
    end
    updateVisualSelection(0, {startSel[1], startSel[2] - 1 }, {endSel[1], endSel[2] - 1}, false)
end

return M
