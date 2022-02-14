
local function map(mode, from, to)
    vim.api.nvim_set_keymap(mode, from, to, { expr = false, noremap = false })
end
local function noremap(mode, from, to)
    vim.api.nvim_set_keymap(mode, from, to, { expr = false, noremap = true })
end

local function nnoremap(from, to)
    noremap('n', from, to)
end
local function tnoremap(from, to)
    noremap('t', from, to)
end
local function inoremap(from, to)
    noremap('i', from, to)
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

nnoremap('<leader><leader>', ':call search("<++>", "cw")<cr>c4l')

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
onoremap('id', ":lua require 'mytextobj'.documentTextObj()<cr>")
xnoremap('id', ":lua require 'mytextobj'.documentTextObj()<cr>")
onoremap('ie', ":lua require 'mytextobj'.expressionTextObj()<cr>")
xnoremap('ie', ":lua require 'mytextobj'.expressionTextObj()<cr>")
onoremap('ii', ":lua require 'mytextobj'.indentTextObj()<cr>")
xnoremap('ii', ":lua require 'mytextobj'.indentTextObj()<cr>")


-- Surround extension
nnoremap('dsf', ':call formatting#delete_surrounding_func()<cr>')
nnoremap('csf', ':call formatting#change_surrounding_func("")<cr>')

-- Unimpared extension
nnoremap('[t', ':tabprevious<cr>')
nnoremap(']t', ':tabnext<cr>')
nnoremap('[g', ':lua require"gitsigns".prev_hunk()<cr>')
nnoremap(']g', ':lua require"gitsigns".next_hunk()<cr>')
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


-- F key maps
nnoremap('<F5>', ':nohl<cr>:lua require"user.helpers".reload("colorizer")<cr>:ColorizerToggle<cr>')
nnoremap('<F6>', ':set list!<cr>')
nnoremap('<F7>', ':set wrap!<cr>')
nnoremap('<F8>', ':ColorizerToggle<cr>')

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

inoremap('<Tab>', 'v:lua.smart_tab()')
inoremap('<S-Tab>', 'v:lua.smart_tab_backward()')

-- Leader mappings

