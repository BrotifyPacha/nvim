
-- Dap install
local dap_install = require('dap-install')
dap_install.setup({
    installation_path = vim.fn.stdpath('config') .. '/debuggers/',
})

-- Dap core
local dap = require('dap')
dap.set_log_level('TRACE')
dap.adapters.php = {
    type = 'executable',
    command = 'node',
    args = { vim.fn.stdpath('config') .. '/debuggers/php/vscode-php-debug/out/phpDebug.js' }
}
dap.configurations.php = {
    {
        type = 'php',
        request = 'launch',
        name = 'Listen for Xdebug',
        stopOnEntry = true,
        pathMappings = {
            ['/var/www'] = '/home/gusev/workspace/${workspaceFolderBasename}/app',
            -- ['/home/pgusev/workspace/${workspaceFolderBasename}'] = '/home/brotifypacha/workspace/servers/devel2/workspace/${workspaceFolderBasename}',
            -- ['/home/pgusev/workspace/retorr'] = '${workspaceFolder}',
        },
        port = 9009
    }
}

vim.fn.sign_define('DapBreakpoint', { text='●', texthl='ErrorMsg', linehl = '', numhl = 'ErrorMsg' })
vim.fn.sign_define('DapBreakpointCondition', { text='◆', texthl='ErrorMsg', linehl = '', numhl = 'ErrorMsg' })
vim.fn.sign_define('DapStopped', { text='', texthl='Error', linehl = '', numhl = 'Error' })

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
            'repl',
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

local flags = { noremap = true, silent = true }

vim.api.nvim_set_keymap('n', '<leader>ds', ':lua require("dap").continue()<cr>',          flags)
vim.api.nvim_set_keymap('n', '<leader>dj', ':lua require("dap").step_over()<cr>',         flags)
vim.api.nvim_set_keymap('n', '<leader>dl', ':lua require("dap").step_into()<cr>',         flags)
vim.api.nvim_set_keymap('n', '<leader>dh', ':lua require("dap").step_out()<cr>',          flags)
vim.api.nvim_set_keymap('',  '<leader>dd', ':lua require("dap").toggle_breakpoint()<cr>', flags)
vim.api.nvim_set_keymap('n',  '<leader>df',':lua require("dap").toggle_breakpoint(vim.fn.input("Enter condition: "))<cr>', flags)
vim.api.nvim_set_keymap('',  '<F11>',      ':lua require("dapui").toggle()<cr>',          flags)
vim.api.nvim_set_keymap('v',  '<leader>de', ':lua require("helpers").visualExec(\'require("dapui").eval()\')<cr>', flags)
vim.api.nvim_set_keymap('n',  '<leader>de', ':lua require("dapui").eval()<cr>', flags)

vim.api.nvim_set_keymap('n', '<S-up>',  ':lua require("dap").reverse_continue()<cr>',  flags)
vim.api.nvim_set_keymap('n', '<S-down>',':lua require("dap").continue()<cr>',  flags)
vim.api.nvim_set_keymap('n', '<up>',    ':lua require("dap").step_back()<cr>', flags)
vim.api.nvim_set_keymap('n', '<down>',  ':lua require("dap").step_over()<cr>', flags)
vim.api.nvim_set_keymap('n', '<right>', ':lua require("dap").step_into()<cr>', flags)
vim.api.nvim_set_keymap('n', '<left>',  ':lua require("dap").step_out()<cr>',  flags)

