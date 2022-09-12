
local helpers = require"user.helpers"

local M = {}

M.golangEfm = "%A %.%#Error Trace: %#%f:%l,%C %.%#Error: %m,%Z %.%#Test: %#%o,%f:%l:%c:%m,\\ %#%f:%l: %m,--- FAIL: %m %.%#"

function M.runTests(cmd, efmString)
    local testsFailed = false
    local testRunLines = require"user.helpers".getCmdOutputLines(cmd)

    local errorLocations = {}
    vim.tbl_filter(
        function (item)
            if item.valid == 1 then
                --- If item is empty we grep matched text ourselves
                if item.bufnr == 0 and item.col == 0 and item.lnum == 0 then
                    local messageMatch = {}
                    local grepTestName = helpers.getCmdOutputLines("grep -Rin '" .. item.text .. "'")
                    for _, match in pairs(grepTestName) do
                        messageMatch[#messageMatch+1] = match
                    end
                    if #messageMatch > 1 then
                        print("grep: multiple matches found")
                    else
                        local foundItems = vim.fn.getqflist({lines = messageMatch}).items
                        if #foundItems ~= 0 then
                            foundItems[1].text = item.text
                            item = foundItems[1]
                        end
                    end
                end
                --- Check that matched file exists
                local filepath = vim.fs.normalize(vim.api.nvim_buf_get_name(item.bufnr))
                if not CheckFileExists(filepath) then
                    local filename = string.gsub(filepath, ".+/", "")
                    local searchPath = vim.fn.getcwd(0)
                    filepath = vim.fs.find(filename, { path = searchPath, type = 'file' })
                    if filepath == nil then
                        return false
                    end
                    filepath = filepath[1]
                end
                errorLocations[#errorLocations+1] = {
                    filename = filepath,
                    lnum = item.lnum,
                    text = item.text
                }
                return true
            else
                return false
            end
        end,
        vim.fn.getqflist({
            efm = efmString,
            lines = testRunLines
        }).items
    )
    vim.fn.setqflist({}, 'r', {title = 'Test failures', items=errorLocations})

    testsFailed = #vim.fn.getqflist() ~= 0
    if testsFailed then
        vim.cmd "copen | .cc"
    else
        vim.cmd "cclose"
    end

    vim.t.latest_test_run_failed = testsFailed
    return testsFailed
end

return M
