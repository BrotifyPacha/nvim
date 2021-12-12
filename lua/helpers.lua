
local M = {}

function M.unrequire(m)
    package.loaded[m] = nil
end

return M
