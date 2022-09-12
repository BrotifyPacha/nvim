local M = {}
local wk_reg = require 'which-key'.register

local function map(mode, from, to)
    vim.api.nvim_set_keymap(mode, from, to, { expr = false, noremap = false })
end
local function noremap(mode, from, to, bufonly)
    if bufonly ~= nil then
        vim.api.nvim_buf_set_keymap(0, mode, from, to, { expr = false, noremap = true })
    else
        vim.api.nvim_set_keymap(mode, from, to, { expr = false, noremap = true })
    end
end

local function buf_nnoremap(from, to)
    noremap('n', from, to, true)
end
local function nnoremap(from, to)
    noremap('n', from, to)
end
local function inoremap(from, to)
    noremap('i', from, to)
end
local function inoremapexpr(from, to)
    vim.api.nvim_set_keymap('i', from, to, { expr = true, noremap = true })
end
local function vnoremap(from, to)
    noremap('v', from, to)
end
local function tnoremap(from, to)
    noremap('t', from, to)
end
local function onoremap(from, to)
    noremap('o', from, to)
end
local function xnoremap(from, to)
    noremap('x', from, to)
end

local function nmap(from, to)
    map('n', from, to)
end
local function vmap(from, to)
    map('v', from, to)
end
local function xmap(from, to)
    map('x', from, to)
end

-- Plugin mappings
-- -- Easy align
nmap('ga', '<Plug>(EasyAlign)')
xmap('ga', '<Plug>(EasyAlign)')
-- -- Exchange
nmap('cx', '<Plug>(Exchange)')
nmap('cxx', '<Plug>(ExchangeLine)')
-- -- Surround
nmap('s', '<Plug>Ysurround')
nmap('ss', '<Plug>Yssurround')
vmap('s', '<Plug>VSurround')
nmap('S', 's')


-- Text objects
onoremap('id', "<cmd>lua require 'mytextobj'.documentTextObj()<cr>")
xnoremap('id', "<cmd>lua require 'mytextobj'.documentTextObj()<cr>")
onoremap('ie', "<cmd>lua require 'mytextobj'.expressionTextObj()<cr>")
xnoremap('ie', "<cmd>lua require 'mytextobj'.expressionTextObj()<cr>")
onoremap('ii', "<cmd>lua require 'mytextobj'.indentTextObj()<cr>")
xnoremap('ii', "<cmd>lua require 'mytextobj'.indentTextObj()<cr>")


-- Surround extension
nnoremap('dsf', '<cmd>call formatting#delete_surrounding_func()<cr>')
nnoremap('csf', '<cmd>call formatting#change_surrounding_func("")<cr>')

-- Unimpared extension
nnoremap('[t', ':tabprevious<cr>')
nnoremap(']t', ':tabnext<cr>')
nnoremap('[g', '<cmd>lua require"gitsigns".prev_hunk()<cr>')
nnoremap(']g', '<cmd>lua require"gitsigns".next_hunk()<cr>')
nnoremap('g]p', 'ddmm}P`m:call repeat#set("m]p")<cr>')
nnoremap('g[p', 'ddkmm{p`m:call repeat#set("m[p")<cr>')

-- Misc key maps
nnoremap('n', 'nzz')
nnoremap('N', 'Nzz')
nnoremap('gF', ':e <cfile><cr>')
nnoremap('cy', '"*y')
nnoremap('cp', ':set paste | normal! "*p:set nopaste<cr>')

nnoremap('cw', 'ciw')
nnoremap('vv', '^v$h')
nnoremap('Y', 'yg_')

nnoremap('Q', '@@')
nnoremap('q:', '<nop>')
nnoremap('q/', '<nop>')
nnoremap('q?', '<nop>')


local workspaceDir = '{ path="$HOME/workspace/", category="workspace" }'
local pluginsDir = '{ path="$HOME/.local/share/nvim/site/pack/packer/start/", category="plugin" }'
local k8sMigratorDir = '{ path="/tmp/k8s-repository-migrator-git/", category="k8s-migrator" }'
local configsDir = '{ path="$HOME/.config/", category="configs" }'
local dirs = '{'.. workspaceDir ..', '.. pluginsDir ..'}'
-- F key maps
nnoremap('<F1>', '<cmd>WhichKey F1<cr>')
wk_reg {
    ["F1"] = {
        name = "Change working directory",
        ["<F1>"] = { '<cmd>lua require"user.helpers".PickWorkingDir("tcd", '.. dirs ..')<cr>', "workspace/plugins", },
        ["l"] = { '<cmd>lua require"user.helpers".PickWorkingDir("lcd", '.. dirs ..')<cr>', "workspace/plugins (local)", },
        ["K"] = { '<cmd>lua require"user.helpers".PickWorkingDir("tcd", {'.. k8sMigratorDir ..'})<cr>', "k8s-migrator", },
        ["k"] = { '<cmd>lua require"user.helpers".PickWorkingDir("lcd", {'.. k8sMigratorDir ..'})<cr>', "k8s-migrator (local)", },
        ["C"] = { '<cmd>lua require"user.helpers".PickWorkingDir("tcd", {'.. configsDir ..'})<cr>', "configs", },
        ["c"] = { '<cmd>lua require"user.helpers".PickWorkingDir("lcd", {'.. configsDir ..'})<cr>', "configs (local)", },
    },
}

nnoremap('<F2><F2>', '<cmd>set spell!<cr>')
nnoremap('<F2>g',    'zg')
nnoremap('<F2>b',    'zw')
nnoremap('<F2>u',    '<cmd>spellundo')

nnoremap('<F3>3',  '<cmd>set ff=dos<cr>')
nnoremap('<F3>4',  '<cmd>set ff=unix<cr>')
nnoremap('<F3>ee', '<cmd>edit!<cr>')
nnoremap('<F3>ec', '<cmd>edit! ++enc=cp1251<cr>')
nnoremap('<F3>eu', '<cmd>edit! ++enc=utf-8<cr>')
nnoremap('<F3>el', '<cmd>edit! ++enc=latin1<cr>')
nnoremap('<F3>cc', '<cmd>set fileencoding=cp1251 | w!<cr>')
nnoremap('<F3>cu', '<cmd>set fileencoding=utf8 | w!<cr>')
nnoremap('<F3>cl', '<cmd>set fileencoding=latin1 | w!<cr>')

nnoremap('<F5>', '<cmd>nohl<cr>:lua require"user.helpers".reload("colorizer")<cr>:ColorizerToggle<cr>')
nnoremap('<F6>', '<cmd>set list!<cr>')
nnoremap('<F7>', '<cmd>set wrap!<cr>')
nnoremap('<F8>', '<cmd>ColorizerToggle<cr>')

nnoremap('<F9><F9>',  '<cmd>silent call ReopenTerminal()<cr>')
nnoremap('<F9><F10>', '<cmd>silent call NewTerminal()<cr>')
nnoremap('<F9>p',     '<cmd>call RunCommand("python", "")<cr>')
nnoremap('<F9>q',     '<cmd>setlocal syntax=<cr>')
nnoremap('<F9>l',     '<cmd>setlocal syntax=log<cr>')

-- Terminal mode key maps
tnoremap('<Esc>', '<C-\\><C-n>')

-- Insert mode key maps
inoremap('<C-f>', '<C-x><C-f>')
inoremap('<C-l>', '<C-x><C-l>')

-- Smart tab
local function t(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end
function _G.smart_tab()
    return vim.fn.pumvisible() == 1 and t'<C-n>' or t'<Tab>'
end
function _G.smart_tab_backward()
    return vim.fn.pumvisible() == 1 and t'<C-p>' or t'<S-Tab>'
end

map('v', '<Tab>', '<Plug>(snippy-cut-text)')

inoremapexpr('<Tab>', 'v:lua.smart_tab()')
inoremapexpr('<S-Tab>', 'v:lua.smart_tab_backward()')

-- Leader mappings

nnoremap('<leader><leader>', ':call search("<++>", "cw")<cr>c4l')
nnoremap('<leader><tab>', ':tabnext<cr>')
nnoremap('<leader>e', "<cmd>NvimTreeToggle<cr>")
nnoremap('<leader>l', "<C-w>l")
nnoremap('<leader>h', "<C-w>h")
nnoremap('<leader>j', "<C-w>j")
nnoremap('<leader>k', "<C-w>k")
nnoremap('<leader>H', "<cmd>vsplit<cr>")
nnoremap('<leader>J', "<cmd>bel split<cr>")
nnoremap('<leader>K', "<cmd>split<cr>")
nnoremap('<leader>L', "<cmd>vert bel split<cr>")
nnoremap('<leader>o', "<cmd>let g:goyo_preset=1 |Goyo<cr>")

wk_reg {
    ["<leader>"] = {
        ["<space>"] = "Goto next <++>",
        ["<tab>"] = "next tab",
        e = "File explorer",
        h = "which_key_ignore",
        j = "which_key_ignore",
        k = "which_key_ignore",
        l = "which_key_ignore",
        H = "which_key_ignore",
        J = "which_key_ignore",
        K = "which_key_ignore",
        L = "which_key_ignore",
        o = "goyo",

        d = {
            name = "debug",
            a = "start with args",
            s = "start/continue",
            p = "repeat previous run",
            c = "run to cursor",
            d = "toggle breakpoint",
            f = "toggle If breakpoint",
            e = "eval under cursor",
        },
    }
}

wk_reg {
    ['<leader>dt'] = {
        name = "run tests",
        t = {}
    }
}

nnoremap('<leader>wq' , '<cmd>q<cr>')
nnoremap('<leader>ww' , '<cmd>w<cr>')
nnoremap('<leader>wd' , '<cmd>windo diffthis<cr>')
nnoremap('<leader>wr' , '<C-w>r<cr>')
nnoremap('<leader>wF' , '<cmd>lua require("user.helpers").winOpenFloat(0)<cr>')
nnoremap('<leader>wf' , '<cmd>lua require("user.helpers").winSelectFloat()<cr><cmd>call repeat#set("<leader>wf")<cr>')
nnoremap('<leader>wh' , '<cmd>lua require("user.helpers").winMoveFloat(0, -1)<cr><cmd>call repeat#set("<leader>wh")<cr>')
nnoremap('<leader>wj' , '<cmd>lua require("user.helpers").winMoveFloat(1, 0)<cr><cmd>call repeat#set("<leader>wj")<cr>')
nnoremap('<leader>wk' , '<cmd>lua require("user.helpers").winMoveFloat(-1, 0)<cr><cmd>call repeat#set("<leader>wk")<cr>')
nnoremap('<leader>wl' , '<cmd>lua require("user.helpers").winMoveFloat(0, 1)<cr><cmd>call repeat#set("<leader>wl")<cr>')
nnoremap('<leader>w2' , '<cmd>lua vim.api.nvim_win_set_width(0, math.floor(vim.api.nvim_get_option("columns") / 2))<cr>')
nnoremap('<leader>w3' , '<cmd>lua vim.api.nvim_win_set_width(0, math.floor(vim.api.nvim_get_option("columns") / 3))<cr>')
nnoremap('<leader>w4' , '<cmd>lua vim.api.nvim_win_set_width(0, math.floor(vim.api.nvim_get_option("columns") / 4))<cr>')
nnoremap('<leader>w5' , '<cmd>lua vim.api.nvim_win_set_width(0, math.floor(vim.api.nvim_get_option("columns") / 5))<cr>')
wk_reg {
    ['<leader>w'] = {
        name = "windows",
        q = 'close window',
        w = 'save',
        d = 'diff windows',
        r = 'rotate',
        ['2'] = 'resize to 1/2',
        ['3'] = 'resize to 1/3',
        ['4'] = 'resize to 1/4',
        ['5'] = 'resize to 1/5',
        F = 'make window Floating',
        f = 'select Floating',
        h = 'move float left',
        j = 'move float down',
        k = 'move float top',
        l = 'move float right',
    }
}

nnoremap('<leader>gL', "<cmd>G push --force<cr>")
nnoremap('<leader>gl', "<cmd>G push<cr>")
nnoremap('<leader>gh', "<cmd>G pull<cr>")
nnoremap('<leader>gv', "<cmd>bel vert G log --oneline --graph --decorate --branches<cr>")
nnoremap('<leader>gV', "<cmd>Telescope git_bcommits<cr>")
nnoremap('<leader>gg', "<cmd>bel vert G<cr>:wincmd L<cr>")
nnoremap('<leader>gcc', "<cmd>G commit<cr>")
nnoremap('<leader>gca', "<cmd>G commit --amend<cr>")
nnoremap('<leader>gce', "<cmd>G commit --amend --no-edit<cr>")
nnoremap('<leader>gd', "<cmd>Gdiffsplit<cr>")
nnoremap('<leader>gb', "<cmd>lua require'gitsigns'.blame_line({full=true})<cr>")
nnoremap('<leader>gB', "<cmd>lua require'gitsigns'.blame_line({enter=true})<cr>")
nnoremap('<leader>gu', "<cmd>lua require'gitsigns'.reset_hunk()<cr>:do User PachaHunkStatusChanged<cr>")
nnoremap('<leader>gs', "<cmd>lua require'gitsigns'.stage_hunk()<cr>:do User PachaHunkStatusChanged<cr>")
nnoremap('<leader>gp', "<cmd>lua require'gitsigns'.preview_hunk()<cr>")
nnoremap('<leader>gf', "<cmd>G fetch --all<cr>")
nnoremap('<leader>gF', "<cmd>G fetch --all --prune<cr>")
nnoremap('<leader>gt', "<cmd>Telescope git_branches<cr>")
vnoremap('<leader>gv', ":GBrowse<cr>")
nnoremap('<leader>grr', '<cmd>lua require("user/helpers").xdgOpen(require("user/helpers").getRemoteLink())<cr>')
nnoremap('<leader>grp', '<cmd>lua require("user/helpers").xdgOpen( require("user/helpers").getRemoteLink() .. "/-/pipelines")<cr>')

wk_reg {
    ['<leader>g'] = {
        name = 'git',
        L = 'push (force)',
        l = 'push',
        h = 'pull',
        v = 'view history',
        V = 'view file history',
        g = 'status',
        c = {
            name = 'commit',
            c = 'commit',
            a = 'amend',
            e = 'amend (no-edit)',
            r = 'amend (no-edit, reset-author)',
        },
        d = 'diff split',
        b = 'blame',
        B = 'blame short',
        u = 'undo hunk',
        s = 'stage hunk',
        p = 'preview hunk',
        f = 'fetch all',
        F = 'fetch all (prune)',
        r = {
            name = 'remote actions',
            r = 'view repo',
            p = 'view pipelines',
        }
    },
}

nnoremap('<leader>rr', ':call RenameLocalVariable()<cr>')
nnoremap('<leader>rt', ':call formatting#toggle_multiline_args()<cr>')
nnoremap('<leader>rs', ':call formatting#go_snake_case(0)<cr>')
nnoremap('<leader>rS', ':call formatting#go_snake_case(1)<cr>')
nnoremap('<leader>rc', ':call formatting#go_camel_case(0)<cr>')
nnoremap('<leader>rC', ':call formatting#go_camel_case(1)<cr>')
nnoremap('<leader>rm', ':call formatting#squash_blank_lines()<cr>')
nnoremap('<leader>rd', ':call AddDocString()<cr>')
wk_reg {
    ['<leader>r'] = {
        name = 'refactor',
        r = 'rename local var',
        t = 'toggle multiline args',
        s = 'snake_case',
        S = 'SNAKE_CASE',
        c = 'camelCase',
        C = 'CamelCase',
        m = 'merge blanks',
        d = 'add doc string',
    }
}

nnoremap('<leader>td', '<cmd>tcd %:h<cr>')
nnoremap('<leader>tt', '<cmd>tabnew<cr>')
nnoremap('<leader>tc', '<cmd>tabclose<cr>')
nnoremap('<leader>tl', '<cmd>tabmove +1<cr><cmd>call repeat#set("<leader>tl")<cr>')
nnoremap('<leader>th', '<cmd>tabmove -1<cr><cmd>call repeat#set("<leader>th")<cr>')
wk_reg {
    ['<leader>t'] = {
        name = 'tabs',
        d = 'switch tab working dir',
        t = 'open tab',
        c = 'close tab',
        l = 'move tab right',
        h = 'move tab left',
    }
}

-- nnoremap('<leader>bb', ':bw!<cr>')
-- nnoremap('<leader>bl', ':buffers<cr>')
-- nnoremap('<leader>bn', ':bnext<cr>')
-- nnoremap('<leader>bp', ':bprevious<cr>')
-- wk_reg {
--         ['<leader>bb'] = 'wipeout buffer',
--         ['<leader>bl'] = 'list buffers',
--         ['<leader>bn'] = 'next buffer',
--         ['<leader>bp'] = 'previous buffer',
-- }

nnoremap('<leader>qc', ':cclose<cr>')
wk_reg {
    ['<leader>q'] = {
        name = 'quickfix',
        c = 'close',
    }
}

vim.cmd
[[
augroup pacha_filetype_mappings
    autocmd!
    autocmd FileType * lua require'user.mappings'.set_filetype_specific_mappings()
augroup end
]]

buf_nnoremap('<leader>fh', '<cmd>vert bo split $VIMRUNTIME/syntax/hitest.vim | so % | wincmd p | wincmd q<cr>')
-- Make commands
nnoremap('<leader>fk', '<cmd>!make up<cr>')
nnoremap('<leader>fj', '<cmd>!make down<cr>')
nnoremap('<leader>fl', '<cmd>!make run<cr>')
wk_reg {
    ["<leader>f"] = {
        name = "filetype specific",
        h = "open hitest.vim",
    }
}

function M.set_filetype_specific_mappings()
    local ft = vim.api.nvim_buf_get_option(0, 'ft')
    local fprefix = '<leader>f'
    if ft == "vim" then
        -- Vim
        buf_nnoremap(fprefix .. 's', ':w | so %<cr>')
    elseif ft == "lua" then
        -- Lua
        buf_nnoremap(fprefix .. 's', ':w | so %<cr>')
    elseif ft == "markdown" then
        -- Markdown
        buf_nnoremap(fprefix .. 'p', ':MarkdownPreviewToggle<cr>')
    elseif ft == 'go' then
        buf_nnoremap(fprefix .. 't', '<cmd>lua require"user.runner".runTests("go test ./...", require"user.runner".golangEfm)<cr>')
        -- nnoremap('<leader>sb', '<cmd>cexpr system("go build " . )<cr>')
    end
end

function CustomCtrlAHandler()
    local line = vim.api.nvim_get_current_line()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local word = vim.fn.expand("<cword>")
    while string.sub(line, cursor[2]+1, cursor[2]+1) == " " do
        cursor[2] = cursor[2] + 1
        vim.cmd('normal! l')
    end
    if word == "true" or word == "false" then
        if word == 'true' then
            vim.cmd("normal! ciwfalse")
        end
        if word == 'false' then
            vim.cmd("normal! ciwtrue")
        end
        return
    end
    vim.cmd("normal! ")
end
nnoremap("<C-a>", "<cmd>lua CustomCtrlAHandler()<cr>")

return M

