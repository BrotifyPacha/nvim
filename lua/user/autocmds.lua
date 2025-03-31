
vim.api.nvim_create_autocmd('TextYankPost', {
    pattern = '*',
    callback = function ()
        require('vim.hl').on_yank({higroup='PmenuSel', timeout=250})
    end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
    pattern = '*',
    callback = function (event)
        if vim.v.event.regname == "*" then
            vim.fn.setreg("+", vim.fn.getreg("*"))
        end
        if vim.v.event.regname == "+" then
            vim.fn.setreg("*", vim.fn.getreg("+"))
        end
    end,
})
vim.api.nvim_create_autocmd('TabEnter', {
    pattern = '*',
    callback = function ()
        local api = require("nvim-tree.api")
        wd = vim.fn.getcwd()
        api.tree.change_root(wd)
    end,
})

local refresh_fugitive_callback = 'fugitive#ReloadStatus'
vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = '*',
    callback = refresh_fugitive_callback,
})
vim.api.nvim_create_autocmd('User', {
    pattern = 'PachaHunkStatusChanged',
    nested = true,
    callback = refresh_fugitive_callback,
})

vim.api.nvim_create_augroup('pacha_recording_status', { clear = true })
vim.api.nvim_create_autocmd({'RecordingEnter'}, {
    group = 'pacha_recording_status',
    pattern = '*',
    callback = function ()
        vim.g.recording = true
    end
})
vim.api.nvim_create_autocmd({'RecordingLeave'}, {
    group = 'pacha_recording_status',
    pattern = '*',
    callback = function ()
        vim.g.recording = false
    end
})

vim.api.nvim_create_autocmd({'VimResized'}, {
    pattern = '*',
    callback = function ()
        vim.cmd(':wincmd =')
    end
})
