
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
        -- stopOnEntry = true,
        pathMappings = function ()
            return {
                ['/var/www'] = vim.fn.getcwd() .. '/app'
            }
        end,
        port = 9000
    }
}

dap.adapters.go = function(callback, config)
    local stdout = vim.loop.new_pipe(false)
    local stderr = vim.loop.new_pipe(false)
    local handle
    local pid_or_err
    local port = 38697
    local opts = {
        stdio = {nil, stdout, stderr},
        args = {"dap", "-l", "127.0.0.1:" .. port},
        detached = true
    }
    handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
        stdout:close()
        stderr:close()
        handle:close()
        if code ~= 0 then
            print('dlv exited with code', code)
        end
    end)
    assert(handle, 'Error running dlv: ' .. tostring(pid_or_err))

    local read_output = function(stream, pipe)
        return function(err, chunk)
            assert(not err, err)
            if chunk then
                vim.schedule(function()
                    require('dap.repl').append('[' .. stream .. '] ' .. chunk)
                end)
            end
        end
    end

    stdout:read_start(read_output('stdout', stdout))
    stderr:read_start(read_output('stderr', stderr))

    -- Wait for delve to start
    vim.defer_fn(
    function()
        callback({type = "server", host = "127.0.0.1", port = port})
    end,
    100)
end
-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
function runLast()
    vim.t.customDapRunLast = true
    dap.run_last()
end

function runNewOrRunLast(default)
    return function ()
        if vim.t.customDapRunLast ~= nil then
            vim.t.customDapRunLast = nil
            return vim.t.customDapRunLastFile
        end
        vim.t.customDapRunLastFile = vim.fn.expand('%:p')
        return default
    end
end

function runSpecificTest()
  return function ()
    if vim.t.customDapRunLast ~= nil then
      return { '-test.run', vim.t.customDapRunLastFunc }
    end
    local func = vim.fn.expand('<cword>')

    vim.ui.input(
      {
        prompt = 'Enter name of function to test: ',
        default = func,
      },
      function (input)
        func = input
        vim.t.customDapRunLastFunc = func
      end
    )
    return { '-test.run', func }
  end
end

dap.configurations.go = {
    {
        type = "go",
        name = "Debug file",
        request = "launch",
        program = runNewOrRunLast("${file}"),
        args = {},
    },
    {
        type = "go",
        name = "Debug project",
        request = "launch",
        program = "${workspaceFolder}",
        args = {},
    },
    {
      type = "go",
      name = "Debug pre-compiled binary",
      request = "launch",
      mode = "exec",
      program = "./_debug_bin",
    },
    {
        type = "go",
        name = "Debug test (File)",
        request = "launch",
        mode = "test",
        program = runNewOrRunLast("${file}")
    },
    {
      type = "go",
      name = "Debug test (Func)",
      request = "launch",
      mode = "test",
      program = "./${relativeFileDirname}",
      args = runSpecificTest(),
    },
    -- works with go.mod packages and sub packages
    {
        type = "go",
        name = "Debug test (Project)",
        request = "launch",
        mode = "test",
        program = "./${relativeFileDirname}"
    }
}

require('dap-python').setup('/usr/bin/python')
dap.configurations.python = {
    {
        type = 'python',
        request = 'launch',
        name = 'Debug file',
        program = runNewOrRunLast('${file}'),
    }
}

vim.fn.sign_define('DapBreakpoint',          { text='', texthl='ErrorMsg', linehl = '', numhl = 'ErrorMsg' })
vim.fn.sign_define('DapBreakpointCondition', { text='卑', texthl='ErrorMsg', linehl = '', numhl = 'ErrorMsg' })
vim.fn.sign_define('DapBreakpointRejected',  { text='', texthl='ErrorMsg', linehl = '', numhl = 'ErrorMsg' })
vim.fn.sign_define('DapStopped', { text='', texthl='', linehl = '', numhl = 'Error' })

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
                -- 'stacks'
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

local flags = { noremap = true, silent = true }

vim.api.nvim_set_keymap('n', '<leader>ds', ':lua require("dap").continue()<cr>',          flags)
vim.api.nvim_set_keymap('n', '<leader>da', ':lua dapRunConfigWithArgs()<cr>',          flags)
vim.api.nvim_set_keymap('n', '<leader>dp', ':lua runLast()<cr>',          flags)
vim.api.nvim_set_keymap('',  '<leader>dd', ':lua require("dap").toggle_breakpoint()<cr>', flags)
vim.api.nvim_set_keymap('n',  '<leader>df',':lua require("dap").toggle_breakpoint(vim.fn.input("Enter condition: "))<cr>', flags)
vim.api.nvim_set_keymap('',  '<F11>',      ':lua require("dapui").toggle()<cr>',          flags)
vim.api.nvim_set_keymap('v',  '<leader>de', ':lua require("user.helpers").visualExec(\'require("dapui").eval()\')<cr>', flags)
vim.api.nvim_set_keymap('n',  '<leader>de', ':lua require("dapui").eval()<cr>', flags)
vim.api.nvim_set_keymap('n',  '<leader>dc', ':lua require("dap").run_to_cursor()<cr>', flags)

vim.api.nvim_set_keymap('n', '<S-up>',  ':lua require("dap").reverse_continue()<cr>',  flags)
vim.api.nvim_set_keymap('n', '<S-down>',':lua require("dap").continue()<cr>',  flags)
vim.api.nvim_set_keymap('n', '<up>',    ':lua require("dap").step_back()<cr>', flags)
vim.api.nvim_set_keymap('n', '<down>',  ':lua require("dap").step_over()<cr>', flags)
vim.api.nvim_set_keymap('n', '<right>', ':lua require("dap").step_into()<cr>', flags)
vim.api.nvim_set_keymap('n', '<left>',  ':lua require("dap").step_out()<cr>',  flags)
vim.api.nvim_set_keymap('n', '<S-left>',':lua require("dap").terminate(nil, nil, killDebuggers)<cr>',  flags)

function _G.killDebuggers()
    vim.api.nvim_command [[
        silent !kill -9 $(ps aux | grep nvim.debuggers | awk '{ print $2 }')
    ]]
end

function _G.dapRunConfigWithArgs()
    local dap = require('dap')
    local ft = vim.bo.filetype
    if ft == "" then
        print("Filetype option is required to determine which dap configs are available")
        return
    end
    local configs = dap.configurations[ft]
    if configs == nil then
        print("Filetype \"" .. ft .. "\" has no dap configs")
        return
    end
    local mConfig = nil
    vim.ui.select(
        configs,
        {
            prompt = "Select config to run: ",
            format_item = function(config)
                return config.name
            end
        },
        function(config)
            mConfig = config
        end
    )
    vim.api.nvim_command("redraw")
    if mConfig == nil then
        return
    end
    vim.ui.input(
        {
            prompt = mConfig.name .." - with args: ",
        },
        function(input)
            if input == nil then
                return
            end
            local args = vim.split(input, ' ', true)
            mConfig.args = args
            dap.run(mConfig)
        end
    )
end
