
local colors = {
    yellow   = '#f3e430',
    cyan     = '#20bbfc',
    darkblue = '#005f87',
    green    = '#10A778',
    green_dark= '#047046',
    orange   = '#FF8800',
    purple   = '#6855DE',
    blue     = '#008ec4',
    red      = '#e32791',
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
                    local mode_color = {
                        n = colors.cyan,
                        i = colors.purple,
                        v = colors.red,
                        [''] = colors.red,
                        V = colors.red,
                        c = '#000000',
                        -- c = require('lualine.utils.utils').extract_highlight_colors('StatusLine', 'fg'),
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
                        t = require('lualine.utils.utils').extract_highlight_colors('StatusLine', 'fg'),
                    }
                    local status_bg = require('lualine.utils.utils').extract_highlight_colors('StatusLine', 'bg')
                    vim.api.nvim_command( 'hi! LualineMode guifg=' .. status_bg .. ' guibg=' .. mode_color[vim.fn.mode()] )
                    vim.api.nvim_command( 'hi! LualineModeDivider guifg=' .. mode_color[vim.fn.mode()] .. ' guibg=' .. status_bg )
                    return ' '
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
                path = 1
            },
            -- {
            --     function() return '' end,
            --     separator = '',
            --     padding = { left = 1, right = 0 },
            --     color = { fg = '#555' }
            -- },
            {
                'branch',
                color = { fg = colors.green_dark },
                icon = '',
                padding = { left = 1 }
            },
        },
        lualine_c = {
        },
        lualine_x = { 'fileformat' },
        lualine_y = {
            'filetype',
            {
                -- Lsp server name .
                function()
                    local msg = 'None'
                    local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
                    local clients = vim.lsp.get_active_clients()
                    if next(clients) == nil then
                        return msg
                    end
                    local lss = {}
                    for _, client in ipairs(clients) do
                        local filetypes = client.config.filetypes
                        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                            if vim.tbl_contains(lss, client.name) == false then
                                table.insert(lss, client.name)
                            end
                        end
                    end
                    if vim.tbl_isempty(lss) ~= true then
                        return table.concat(lss, ', ')
                    end
                    return msg
                end,
                icon = '謹LSP:',
            },
            'progress',
        },
        lualine_z = {
            { 'location' },
        },
    },
})
