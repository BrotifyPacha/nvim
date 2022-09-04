
local colors = {
    yellow   = '#f3e430',
    cyan     = '#20bbfc',
    darkblue = '#005f87',
    green    = '#10A778',
    orange   = '#FF8800',
    purple   = '#6855DE',
    blue     = '#008ec4',
    red      = '#e32791',
    bright_red = '#ff2761',
    status_fg = require('lualine.utils.utils').extract_highlight_colors('StatusLine', 'fg'),
    status_bg = require('lualine.utils.utils').extract_highlight_colors('StatusLine', 'bg'),
}

local theme = {
    normal = {
        a = { fg = colors.blue, bg = colors.status_bg },
        b = 'StatusLine',
        c = 'StatusLineInv',
        x = 'StatusLineInv',
        y = 'StatusLine',
        z = 'StatusLine'
    },
    inactive = {
        a = 'StatusLine',
        b = 'StatusLine',
        c = 'StatusLine',
        x = 'StatusLine',
        y = 'StatusLine',
        z = 'StatusLine',
    }
}

local dap, dap_err = require'dap'

require 'lualine'.setup({
    options = {
        theme = theme,
        component_separators = '|',
        section_separators = { left = '', right = '' },
    },
    sections = {
        lualine_a = {
            {
                -- mode component
                function()
                    local mode = vim.fn.mode()
                    local mode_color = {
                        ['recording'] = colors.bright_red,
                        n = colors.cyan,
                        i = colors.purple,
                        v = colors.red,
                        [''] = colors.red,
                        V = colors.red,
                        c = '#000000',
                        no = colors.purple,
                        s = colors.red,
                        S = colors.red,
                        [''] = colors.red,
                        ic = colors.red,
                        R = colors.orange,
                        Rv = colors.orange,
                        cv = colors.blue,
                        ce = colors.blue,
                        r = colors.cyan,
                        rm = colors.cyan,
                        ['r?'] = colors.cyan,
                        ['!'] = colors.blue,
                        t = '#000000'
                    }
                    local result = ' '
                    if vim.g.recording then
                        mode = 'recording'
                        result = '雷'
                    end
                    local status_bg = require('lualine.utils.utils').extract_highlight_colors('StatusLine', 'bg')
                    vim.api.nvim_command( 'hi! LualineMode guifg=' .. status_bg .. ' guibg=' .. mode_color[mode] )
                    vim.api.nvim_command( 'hi! LualineModeDivider guifg=' .. mode_color[mode] .. ' guibg=' .. status_bg )
                    return result
                end,
                color = 'LualineMode',
                separator = { right = '' },
                padding = { right = 0, left = 2 },
            },
            {
                function()
                    return ''
                end,
                padding = { right = 0, left = 0 },
                color = 'LualineModeDivider'
            }
        },
        lualine_b = {
            {
                'filename',
                path = 1,
                shorting_target = 0,
            },
            -- {
            --     function() return '' end,
            --     separator = '',
            --     padding = { left = 1, right = 0 },
            --     color = { fg = '#555' }
            -- },
            {
                'branch',
                color = { fg = colors.green },
                icon = '',
                padding = { left = 1 }
            },
        },
        lualine_c = {},
        lualine_x = {
            -- 'fileformat'
        },
        lualine_y = {
            -- {
            --     -- Lsp server name .
            --     function()
            --         local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
            --         local clients = vim.lsp.get_active_clients()
            --         if next(clients) == nil then
            --             return ''
            --         end
            --         local lss = {}
            --         for _, client in ipairs(clients) do
            --             local filetypes = client.config.filetypes
            --             if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
            --                 if vim.tbl_contains(lss, client.name) == false then
            --                     table.insert(lss, client.name)
            --                 end
            --             end
            --         end
            --         if vim.tbl_isempty(lss) ~= true then
            --             return '謹' .. table.concat(lss, ', ')
            --         end
            --         return ''
            --     end,
            -- },
        },
        lualine_z = {
            {
                -- Tests indicator
                function ()
                    if vim.t.latest_test_run_failed == nil then
                        return ''
                    end
                    local icon = ''
                    local color = ''
                    local text = ''
                    local status_bg = require('lualine.utils.utils').extract_highlight_colors('StatusLine', 'bg')
                    if vim.t.latest_test_run_failed then
                        color = colors.red
                        text = '(Fail)'
                    else
                        color = colors.green
                        text = '(Success)'
                    end
                    vim.api.nvim_command( 'hi! LualineTestsIndicator guifg=' .. color .. ' guibg=' .. status_bg )
                    return icon
                end,
                color = 'LualineTestsIndicator',
            },
            {
                function ()
                    if vim.t.latest_test_run_failed == nil then
                        return ''
                    else
                        return '|'
                    end
                end,
                padding = 0,
                separator = ''
            },
            'filetype',
            {
                -- Dap debugging status
                function()
                    if dap_err == nil then
                        local dap_status = require('dap').status()
                        if string.len(dap_status) > 0 then
                            return ' ● ' ..  dap_status .. ' '
                        else
                            return ''
                        end
                    else
                        return ''
                    end
                end,
                color = { fg = colors.red, bg = colors.status_bg },
                padding = '',
            },
            -- 'location',
            'progress',
        },
    },
})
