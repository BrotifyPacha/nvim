
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

vim.api.nvim_create_augroup('pacha_help_filetype', { clear = true })
vim.api.nvim_create_autocmd({'BufRead', 'WinEnter'}, {
    group = 'pacha_help_filetype',
    pattern = '*\\/doc\\/*.txt',
    callback = function ()
        local fname = vim.api.nvim_buf_get_name(0)
        print('fname = ' .. fname .. ', match = ')
        vim.api.nvim_win_set_width(0, 80 + vim.o.numberwidth)
    end
})
