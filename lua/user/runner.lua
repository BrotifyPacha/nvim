
local helpers = require"user.helpers"

local M = {}

local testNamePlaceholder = "%%testName%%"
local testNameLuaRegex = "([%%w-_]+)"

function M.runTests(cmd, failPattern)
    local testsFailed = false
    local testRunLines = require"user.helpers".getCmdOutputLines(cmd)
    -- local re = vim.regex(failPattern)
    failPattern = failPattern:gsub('%(', '%%(')
    failPattern = failPattern:gsub('%)', '%%)')
    failPattern = failPattern:gsub(testNamePlaceholder, testNameLuaRegex)

    local testNames = {}
    for _, line in pairs(testRunLines) do
        local match = string.match(line, failPattern)
        if match ~= nil then
            testsFailed = true
            testNames[#testNames+1] = match
        end
    end

    local testLocations = {}
    -- print(vim.inspect(testNames))
    for _, test in pairs(testNames) do
        local grepTestName = helpers.getCmdOutputLines("grep -Rin " .. test)
        for _, filename in pairs(grepTestName) do
            testLocations[#testLocations+1] = {
                filename = filename:gsub(':%d+.+', ''),
                pattern = test,
            }
        end
    end

    -- print(vim.inspect(testLocations))
    vim.fn.setqflist({}, 'r', {title = "Test failures", items=testLocations})

    errorLocations = {}
    vim.tbl_filter(
        function (item)
            if item.valid == 1 then
                local filename = string.gsub(vim.fs.normalize(vim.api.nvim_buf_get_name(item.bufnr)), ".+/", "")
                local searchPath = vim.fn.getcwd(0)
                local filepath = vim.fs.find(filename, { path = searchPath, type = 'file' })
                if filepath == nil then
                    return false
                end
                errorLocations[#errorLocations+1] = {
                    filename = filepath[1],
                    lnum = item.lnum,
                    text = item.text
                }
                return true
            else
                return false
            end
            -- vim.fs.find({item.})
            -- return item.valid == 1
        end,
        vim.fn.getqflist({lines = testRunLines}).items
    )
    vim.fn.setqflist({}, 'a', {title = 'Test failures', items=errorLocations})

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
