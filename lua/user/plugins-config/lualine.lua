
local colors = {
    yellow   = '#f3e430',
    cyan     = '#20bbfc',
    darkblue = '#005f87',
    green    = '#10A778',
    green_dark= '#08A046',
    orange   = '#FF8800',
    purple   = '#6855DE',
    blue     = '#008ec4',
    red      = '#e32791',
    status_bg = require('lualine.utils.utils').extract_highlight_colors('StatusLine', 'bg'),
}

local theme = {
    normal = {
        a = { fg = colors.blue, bg = colors.status_bg },
        b = 'StatusLineInv',
        c = 'StatusLineFaded',
        x = 'StatusLineFaded',
        y = 'StatusLineInv',
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
        component_separators = '│',
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
                        c = require('lualine.utils.utils').extract_highlight_colors('StatusLine', 'fg'),
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
                    status_bg = require('lualine.utils.utils').extract_highlight_colors('StatusLine', 'bg')
                    vim.api.nvim_command('hi! LualineMode guifg=' .. mode_color[vim.fn.mode()] .. ' guibg=' .. status_bg)
                    return ''
                end,
                color = 'LualineMode',
                separator = { right = '' },
                padding = { right = 1, left = 2 },
            },
        },
        lualine_b = {
            {
                'filename',
                path = 1
            },
            {
                'branch',
                color = { fg = colors.green_dark }
            }
        },
        lualine_c = { 'fileformat' },
        lualine_x = {},
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
                    for _, client in ipairs(clients) do
                        local filetypes = client.config.filetypes
                        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                            return client.name
                        end
                    end
                    return msg
                end,
                icon = '謹LSP:',
            },
            'progress',
        },
        lualine_z = {
            { 'location', color = 'StatusLine' },
        },
    },
})
