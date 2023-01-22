
vim.api.nvim_create_autocmd('TextYankPost', {
    pattern = '*',
    callback = function ()
        require('vim.highlight').on_yank({higroup='PmenuSel', timeout=250})
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
        vim.api.nvim_win_set_width(0, 80 + vim.o.numberwidth)
    end
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
vim.api.nvim_create_augroup('gitlog_ui_change', { clear = true })
vim.api.nvim_create_autocmd({'BufEnter'}, {
    group = 'pacha_recording_status',
    pattern = '*',
    callback = function ()
        if vim.bo.ft == 'git' then
            vim.bo.modifiable = true
            vim.cmd(":silent %s/\\*/●/")
            vim.cmd(":silent %s/|/│/g")
            vim.bo.modifiable = false
        end
    end
})
vim.api.nvim_create_augroup('custom_session', { clear = true })
local helpers = require "user.helpers"
local session = helpers.ExpandEnvs('$HOME/.config/nvim/session')
local mksession = ':mksession! ' .. session
vim.api.nvim_create_autocmd({'VimLeavePre'}, {
    group = 'custom_session',
    pattern = '*',
    callback = function ()
        vim.cmd(mksession)
    end
})
vim.api.nvim_create_autocmd({'VimEnter'}, {
    group = 'custom_session',
    pattern = '*',
    callback = function ()
        if helpers.CheckFileExists(session) then
            vim.cmd(':source ' .. session)
        end
    end
})
vim.api.nvim_create_autocmd({'SessionLoadPost'}, {
    group = 'custom_session',
    pattern = '*',
    callback = function ()
        if helpers.CheckFileExists(session) then
            os.remove(session)
            vim.fn.feedkeys([[:bufdo filetype detect]])
        end
    end
})
vim.cmd('command! SaveSession execute "' .. mksession .. '"' )
