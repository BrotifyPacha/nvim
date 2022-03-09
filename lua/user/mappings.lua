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
nnoremap('<F2><F2>', ':set spell!<cr>')
nnoremap('<F2>g',    'zg')
nnoremap('<F2>b',    'zw')
nnoremap('<F2>u',    ':spellundo')

nnoremap('<F3>3',  ':set ff=dos<cr>')
nnoremap('<F3>4',  ':set ff=unix<cr>')
nnoremap('<F3>ee', ':edit!<cr>')
nnoremap('<F3>ec', ':edit! ++enc=cp1251<cr>')
nnoremap('<F3>eu', ':edit! ++enc=utf-8<cr>')
nnoremap('<F3>el', ':edit! ++enc=latin1<cr>')
nnoremap('<F3>cc', ':set fileencoding=cp1251 | w!<cr>')
nnoremap('<F3>cu', ':set fileencoding=utf8 | w!<cr>')
nnoremap('<F3>cl', ':set fileencoding=latin1 | w!<cr>')

nnoremap('<F5>', ':nohl<cr>:lua require"user.helpers".reload("colorizer")<cr>:ColorizerToggle<cr>')
nnoremap('<F6>', ':set list!<cr>')
nnoremap('<F7>', ':set wrap!<cr>')
nnoremap('<F8>', ':ColorizerToggle<cr>')

nnoremap('<F9><F9>',  ':call ReopenTerminal()<cr>')
nnoremap('<F9><F10>', ':call NewTerminal()<cr>')
nnoremap('<F9>p',     ':call RunCommand("python", "")<cr>')
nnoremap('<F9>q',     ':setlocal syntax=<cr>')
nnoremap('<F9>l',     ':setlocal syntax=log<cr>')

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
nnoremap('<leader>e', ":NvimTreeToggle<cr>")
nnoremap('<leader>l', "<C-w>l")
nnoremap('<leader>h', "<C-w>h")
nnoremap('<leader>j', "<C-w>j")
nnoremap('<leader>k', "<C-w>k")
nnoremap('<leader>H', ":vsplit<cr>")
nnoremap('<leader>J', ":bel split<cr>")
nnoremap('<leader>K', ":split<cr>")
nnoremap('<leader>L', ":vert bel split<cr>")
nnoremap('<leader>o', ":let g:goyo_preset=1 |Goyo<cr>")

wk_reg {
    ["<leader>"] = {
        ["<space>"] = "Goto next <++>",
        ["<Tab>"] = "next tab",
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

        d = { name = "debug" },
        g = { name = "git" },
        q = { name = "quickfix" },
        r = { name = "refactor" },
        t = { name = "tabs" },
        w = { name = "windows" },
        b = { name = "buffers" },
    }
}

nnoremap('<leader>wq' , ':q<cr>')
nnoremap('<leader>ww' , ':w<cr>')
nnoremap('<leader>wd' , ':windo diffthis<cr>')
nnoremap('<leader>wr' , '<C-w>r<cr>')
nnoremap('<leader>w2' , ':lua vim.api.nvim_win_set_width(0, math.floor(vim.api.nvim_get_option("columns") / 2))<cr>')
nnoremap('<leader>w3' , ':lua vim.api.nvim_win_set_width(0, math.floor(vim.api.nvim_get_option("columns") / 3))<cr>')
nnoremap('<leader>w4' , ':lua vim.api.nvim_win_set_width(0, math.floor(vim.api.nvim_get_option("columns") / 4))<cr>')
nnoremap('<leader>w5' , ':lua vim.api.nvim_win_set_width(0, math.floor(vim.api.nvim_get_option("columns") / 5))<cr>')
wk_reg {
    ['<leader>wq'] = 'close window',
    ['<leader>ww'] = 'save',
    ['<leader>wd'] = 'diff windows',
    ['<leader>wr'] = 'rotate',
    ['<leader>w2'] = 'resize to 1/2',
    ['<leader>w3'] = 'resize to 1/3',
    ['<leader>w4'] = 'resize to 1/4',
    ['<leader>w5'] = 'resize to 1/5',
}

nnoremap('<leader>gL', ":G push --force<cr>")
nnoremap('<leader>gl', ":G push<cr>")
nnoremap('<leader>gh', ":G pull<cr>")
nnoremap('<leader>gv', ":bel vert G log --oneline --graph --decorate --branches<cr>")
nnoremap('<leader>gg', ":bel vert G<cr>:wincmd L<cr>")
nnoremap('<leader>gc', ":G commit<cr>")
nnoremap('<leader>gd', ":Gdiffsplit<cr>")
nnoremap('<leader>gb', ":lua require'gitsigns'.blame_line(true)<cr>")
nnoremap('<leader>gu', ":lua require'gitsigns'.reset_hunk()<cr>")
nnoremap('<leader>gs', ":lua require'gitsigns'.stage_hunk()<cr>")
nnoremap('<leader>gp', ":lua require'gitsigns'.preview_hunk()<cr>")
nnoremap('<leader>gt', ":Telescope git_branches<cr>")
vnoremap('<leader>gv', ":GBrowse<cr>")
wk_reg {
    ['<leader>gL'] = 'push (force)',
    ['<leader>gl'] = 'push',
    ['<leader>gh'] = 'pull',
    ['<leader>gv'] = 'view history',
    ['<leader>gg'] = 'status',
    ['<leader>gc'] = 'commit',
    ['<leader>gd'] = 'diff split',
    ['<leader>gb'] = 'blame',
    ['<leader>gu'] = 'undo hunk',
    ['<leader>gs'] = 'stage hunk',
    ['<leader>gp'] = 'preview hunk',
}

-- function! CustomWrapper(opts)
--     let dict = substitute(string(a:opts), "'\\([A-z0-9]\\+\\)':", '\1 =', 'g')
--     let result_url = execute("lua print(require 'fugitivehandlers'.CustomGBrowseHandler(" . dict . "))")
--     return trim(result_url)
-- endfunction

-- let s:handlers = get(g:, 'fugitive_browse_handlers', [])
-- let g:fugitive_browse_handlers = add(s:handlers, 'CustomWrapper')

-- command! -nargs=1 Browse :call BrowseFunc(<q-args>)<cr>
-- function! BrowseFunc(opts)
--     let opts = substitute(a:opts, '#', '\\#', 'g')
--     silent execute '!xdg-open ' . trim(opts)
-- endfunction

nnoremap('<leader>rr', ':call RenameLocalVariable()<cr>')
nnoremap('<leader>rt', ':call formatting#toggle_multiline_args()<cr>')
nnoremap('<leader>rs', ':call formatting#go_snake_case(0)<cr>')
nnoremap('<leader>rS', ':call formatting#go_snake_case(1)<cr>')
nnoremap('<leader>rc', ':call formatting#go_camel_case(0)<cr>')
nnoremap('<leader>rC', ':call formatting#go_camel_case(1)<cr>')
nnoremap('<leader>rm', ':call formatting#squash_blank_lines()<cr>')
nnoremap('<leader>rd', ':call AddDocString()<cr>')
wk_reg {
    ['<leader>rr'] = 'rename local var',
    ['<leader>rt'] = 'toggle multiline args',
    ['<leader>rs'] = 'snake_case',
    ['<leader>rS'] = 'SNAKE_CASE',
    ['<leader>rc'] = 'camelCase',
    ['<leader>rC'] = 'CamelCase',
    ['<leader>rm'] = 'merge blanks',
    ['<leader>rd'] = 'add doc string',
}

nnoremap('<leader><tab>', ':tabnext<cr>')
nnoremap('<leader>td', ':tcd %:h<cr>')
nnoremap('<leader>tt', ':tabnew<cr>')
nnoremap('<leader>tc', ':tabclose<cr>')
nnoremap('<leader>tl', ':tabmove +1<cr>')
nnoremap('<leader>th', ':tabmove -1<cr>')
wk_reg {
        ['<leader><tab>'] = '<++>',
        ['<leader>td'] = '<++>',
        ['<leader>tt'] = '<++>',
        ['<leader>tc'] = '<++>',
        ['<leader>tl'] = '<++>',
        ['<leader>th'] = '<++>',
}

nnoremap('<leader>bb', ':bw!<cr>')
nnoremap('<leader>bl', ':buffers<cr>')
nnoremap('<leader>bn', ':bnext<cr>')
nnoremap('<leader>bp', ':bprevious<cr>')
wk_reg {
        ['<leader>bb'] = '<++>',
        ['<leader>bl'] = '<++>',
        ['<leader>bn'] = '<++>',
        ['<leader>bp'] = '<++>',
}

nnoremap('<leader>qc', ':cclose<cr>')
wk_reg {
        ['<leader>qc'] = 'close',
}

vim.cmd
[[
augroup pacha_filetype_mappings
    autocmd!
    autocmd FileType * lua require'user.mappings'.set_filetype_specific_mappings()
augroup end
]]

buf_nnoremap('<leader>fh', ':vert bo split $VIMRUNTIME/syntax/hitest.vim | so % | wincmd p | wincmd q<cr>')
-- Make commands
nnoremap('<leader>fk', ':!make up<cr>')
nnoremap('<leader>fj', ':!make down<cr>')
nnoremap('<leader>fl', ':!make run<cr>')
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
        buf_nnoremap(fprefix .. 'l', ':MarkdownPreviewToggle<cr>')
    end
end

return M

-- " Filetype specific keymaps maps - starts via <leader>f
-- let g:which_key_vim_map = {
--       \ 'h'    : [':vert bo split $vimruntime\syntax\hitest.vim | so % | wincmd p | wincmd q' , 'open hitest'],
--       \ 'g'    : [':call feedkeys(":call SynStack()\<cr>")' , 'show hi group'],
--       \ 'r'    : [':source %'                               , 'source %'],
--       \ 'v'    : [':source $MYVIMRC'                        , 'source vimrc'],
--       \ 'c'    : {
--           \ 'name' : 'change filetype',
--           \ 'p' : [':set ft=php', 'php']
--           \}
--       \}

-- let g:which_key_python_map = {
--       \ 'i'    : [':call feedkeys("G?\\v^(import|from)\<cr>o")' , 'go to imports'],
--       \ 'r'    : [':call RunCommand("python", expand("%"))' , 'run python script'],
--       \}

-- let g:which_key_markdown_map = {
--       \ 'p'    : [':MarkdownPreviewToggle' , 'toggle preview'],
--       \}

-- let g:which_key_php_map = {
--             \ 'a' : [':call ToggleArtisanServer()', 'toggle artisan serve']
--             \}

-- let g:which_key_project_map = {
--             \ 'name' : 'project menu',
--             \ 't': [ ':call ToggleLibAndProject()', 'toggle library and project' ],
--             \ }

-- function! ToggleArtisanServer()
--     lua require('phpartisan').toggleArtisanServer()
-- endfunction

