local flags = { noremap = true, silent = true }

vim.api.nvim_set_keymap('n', '<leader>ds', ':lua require("dap").continue()<cr>',          flags)
vim.api.nvim_set_keymap('n', '<leader>da', ':lua dapRunConfigWithArgs()<cr>',          flags)
vim.api.nvim_set_keymap('n', '<leader>dp', ':lua runLast()<cr>',          flags)
vim.api.nvim_set_keymap('',  '<leader>dd', ':lua require("dap").toggle_breakpoint()<cr>', flags)
vim.api.nvim_set_keymap('n',  '<leader>df',':lua require("dap").toggle_breakpoint(vim.fn.input("Enter condition: "))<cr>', flags)
vim.api.nvim_set_keymap('n',  '<leader>dF',':lua require("dap").toggle_breakpoint(vim.fn.input("Enter condition: "), vim.fn.input("Enter hit-condition: "))<cr>', flags)
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

vim.keymap.set('n', '<F12>', function ()
  local session = require('dap').session()

  vim.ui.input({ prompt = "memory refernce" }, function (input)
    local r1, r2 = session:request("readMemory", { memoryReference=input, count=0 })
    vim.print(r1, r2)
  end)

end)

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

    vim.ui.select(
        configs,
        {
            prompt = "Select config to run: ",
            format_item = function(config)
                return config.name
            end
        },
        function(config)
            if config == nil then
                return
            end
            require('user.plugins-config.dap.picker').pick_args_and_env(config, function(final_config)
                dap.run(final_config)
            end)
        end
    )
end
