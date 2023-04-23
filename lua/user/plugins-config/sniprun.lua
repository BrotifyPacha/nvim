local scratchFileDir = vim.fn.stdpath("cache") .. "/scratch.nvim"

local scratch = require("scratch")
local sniprun = require("sniprun")

vim.api.nvim_create_augroup('pacha_scratch_buffers', { clear = true })
vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
    group = 'pacha_scratch_buffers',
    pattern = scratchFileDir .. '/*',
    callback = function ()
        require'sniprun.display'.close_all()
        sniprun.run('n')
    end
})

sniprun.setup{
    display = { "Terminal" },
    live_mode_toggle='false',
    live_display = { "Terminal" },
}

-- scratch.setup {
-- 	scratch_file_dir = scratchFileDir,  -- Where the scratch files will be saved
-- 	filetypes = { "json", "xml", "go", "lua", "js", "py", "sh" },   -- filetypes to select from
-- }

