vim.fn.sign_define('DapBreakpoint',          { text='', texthl='Red', linehl = '', numhl = 'Red' })
vim.fn.sign_define('DapBreakpointCondition', { text='󰔶', texthl='Red', linehl = '', numhl = 'Red' })
vim.fn.sign_define('DapBreakpointRejected',  { text='', texthl='Red', linehl = '', numhl = 'Red' })
vim.fn.sign_define('DapStopped',             { text='',  texthl='',    linehl = '', numhl = 'DapStopped' })

require("dapui").setup({
    icons = { expanded = '', collapsed = '' },
    mappings = {
        -- Use a table to apply multiple mappings
        expand = { '<CR>', '<2-LeftMouse>', 'L' },
        open = 'o',
        remove = 'd',
        edit = 'e',
        repl = 'r',
    },
    layouts = {
        {
            elements = {
                { id='breakpoints', size=0.30 },
                { id='scopes',      size=0.45 },
                { id='watches',     size=0.25 },
            },
            size = 0.30,
            position = 'left',
        },
        {
            elements = {
                'repl',
                'stacks'
            },
            size = 0.30,
            position = 'bottom',
        },
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
