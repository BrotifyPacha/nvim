
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
    if testsFailed then
        vim.cmd "copen | .cc"
    else
        vim.cmd "cclose"
    end

    vim.t.latest_test_run_failed = testsFailed
    return testsFailed
end

return M
