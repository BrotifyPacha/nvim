
-- Dap install
local dap_install = require('dap-install')
dap_install.setup({
    installation_path = vim.fn.stdpath('config') .. '/debuggers',
})

-- Dap core
local dap = require('dap')
dap.set_log_level('TRACE')
dap.adapters.php = {
    type = 'executable',
    command = 'node',
    args = { vim.fn.stdpath('config') .. '/debuggers/vscode-php-debug/out/phpDebug.js' }

}

vim.fn.sign_define('DapBreakpoint', { text='ﱣ', texthl='DiffAdd', linehl = '', numhl = 'DiffAdded' })
vim.fn.sign_define('DapBreakpointCondition', { text='ﱣ', texthl='DiffAdd', linehl = '', numhl = 'DiffAdded' })
vim.fn.sign_define('DapStopped', { text='', texthl='Error', linehl = '', numhl = 'Error' })

dap.configurations.php = {
    {
        type = 'php',
        request = 'launch',
        name = 'Listen for Xdebug',
        stopOnEntry = true,
        pathMappings = {
            ['/var/www'] = '/home/brotifypacha/personal/projects/php-personal-home-page/app',
            ['/home/pgusev/workspace/retorr'] = '${worspaceFolder}',
        },
        port = 9000
    }
}

-- Dap UI
require("dapui").setup({
    icons = { expanded = '', collapsed = '' },
    mappings = {
        -- Use a table to apply multiple mappings
        expand = { '<CR>', '<2-LeftMouse>', 'L' },
        open = 'o',
        remove = 'd',
        edit = 'e',
        repl = 'r',
    },
    sidebar = {
        -- You can change the order of elements in the sidebar
        elements = {
            -- Provide as ID strings or tables with 'id' and 'size' keys
            { id = 'breakpoints', size = 0.15 },
            { id = 'scopes', size = 0.50 },
            { id = 'watches', size = 0.35 },
        },
        size = 60,
        position = 'left', -- Can be 'left', 'right', 'top', 'bottom'
    },
    tray = {
        elements = {
            -- 'repl',
            'stacks',
        },
        size = 10,
        position = 'bottom', -- Can be 'left', 'right', 'top', 'bottom'
    },
    floating = {
        max_height = nil, -- These can be integers or a float between 0 and 1.
        max_width = nil, -- Floats will be treated as percentage of your screen.
        border = 'single', -- Border style. Can be 'single', 'double' or 'rounded'
        mappings = {
            close = { 'q', '<Esc>' },
        },
    },
    windows = { indent = 1 },
})

vim.api.nvim_set_keymap('n', '<leader>ds', ':lua require("dap").continue()<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dj', ':lua require("dap").step_over()<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dl', ':lua require("dap").step_into()<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dh', ':lua require("dap").step_out()<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('', '<leader>dd', ':lua require("dap").toggle_breakpoint()<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('', '<F11>', ':lua require("dapui").toggle()<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('', '<leader>de', '<cmd>lua require("dapui").eval()<cr>', { noremap = true, silent = true })

-- nnoremap <silent> <F5> :lua require'dap'.continue()<CR>
-- nnoremap <silent> <F10> :lua require'dap'.step_over()<CR>
-- nnoremap <silent> <F11> :lua require'dap'.step_into()<CR>
-- nnoremap <silent> <F12> :lua require'dap'.step_out()<CR>
-- nnoremap <silent> <leader>b :lua require'dap'.toggle_breakpoint()<CR>
-- nnoremap <silent> <leader>B :lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
-- nnoremap <silent> <leader>lp :lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
-- nnoremap <silent> <leader>dr :lua require'dap'.repl.open()<CR>
-- nnoremap <silent> <leader>dl :lua require'dap'.run_last()<CR>
