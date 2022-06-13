
vim.api.nvim_create_autocmd('TextYankPost', {
    pattern = '*',
    callback = function ()
        require('vim.highlight').on_yank({higroup='PmenuSel', timeout=250})
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
