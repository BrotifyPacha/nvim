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
local function cnoremap(from, to)
  noremap('c', from, to)
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
vmap('s', '<Plug>VSurround')
nmap('S', '<Plug>YSurround')

vim.g['EasyMotion_do_mapping'] = 1
nmap('ss', '<Plug>(easymotion-prefix)')

onoremap('z', '<Plug>(easymotion-prefix)')


-- Text objects
onoremap('id', "<cmd>lua require 'mytextobj'.documentTextObj()<cr>")
xnoremap('id', "<cmd>lua require 'mytextobj'.documentTextObj()<cr>")
onoremap('ii', "<cmd>lua require 'mytextobj'.indentTextObj()<cr>")
xnoremap('ii', "<cmd>lua require 'mytextobj'.indentTextObj()<cr>")

-- camelCaseWordTestingArt3Times
vim.api.nvim_set_keymap('n', '<A-w>', ':call search("[A-Z]")<cr>', { expr = false, noremap = true, nowait = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-b>', ':call search("[A-Z]", "b")<cr>', { expr = false, noremap = true, nowait = true, silent = true })
onoremap('ic', "<cmd>lua require 'mytextobj'.camelCaseTextObj()<cr>")


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
nnoremap('gf', 'gF')
nnoremap('gF', ':e <cfile><cr>')
nnoremap('cy', '"*y')
nnoremap('p', "mpp=']`p")
nnoremap('P', "mpP='[`p")

nnoremap('cw', 'ciw')
nnoremap('vv', '^v$h')
nnoremap('Y', 'yg_')
vnoremap('*', "y/\\V<C-r>=escape(@\", '\\/')<cr><cr>")

nnoremap('Q', '@@')
nnoremap('q:', '<nop>')
nnoremap('q/', '<nop>')
nnoremap('q?', '<nop>')

cnoremap('<C-f>', '<C-f>F/l')

local workspaceDir = '{ path="$HOME/workspace/", category="workspace", maxdepth=2 }'
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
    ["n"] = { ':tcd ~/.config/nvim | e $MYVIMRC <cr>', "neovim config"},
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

nnoremap('<F9><F9>',  '<cmd>lua require"terminal".open_terminal()<cr>')
nnoremap('<F9><F10>',  '<cmd>lua require"terminal".open_new_terminal()<cr>')
vim.api.nvim_set_keymap('n', '<F9>', ':WhichKey F9<cr>', { expr = false, noremap = true })
wk_reg {
  ["F9"] = {
    name = "terminal",
    ["<F9>"] = { '<cmd>lua require"terminal".open_terminal()<cr>', "open/next terminal", },
    ["<F10>"] = { '<cmd>lua require"terminal".open_new_terminal()<cr>', "open new terminal", },
  },
}

-- Terminal mode key maps
tnoremap('<Esc>', '<C-\\><C-n>')

-- Insert mode key maps
inoremap('<C-f>', '<C-x><C-f>')
inoremap('<C-l>', '<C-x><C-l>')

inoremap('<down>', '<-')
inoremap('<up>', '->')

inoremap('<C-r>c', '<C-r>=trim(v:lua.require(\'user.helpers\').getStdoutOf(\'kcolorchooser --print 2>/dev/null\')[0])<cr>')
inoremap('<C-r>f', '<C-r>=expand(\'%\')<cr>')
inoremap('<C-r>t', '<C-r>=expand(\'%:t\')<cr>')
inoremap('<C-r>r', '<C-r>=expand(\'%:t:r\')<cr>')

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

nnoremap('<leader><leader>', ':call search("<-->", "cw")<cr>c4l')
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
    ["<space>"] = "Goto next <-->",
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

function moveWindowPreservingNvimTree(wincmd)
  local nvimTreeOpen = false
  local wins = vim.api.nvim_tabpage_list_wins(0)
  for _, winId in pairs(wins) do
    local bufId = vim.api.nvim_win_get_buf(winId)
    local ft = vim.api.nvim_buf_get_option(bufId, 'ft')
    if ft == 'NvimTree' then
      nvimTreeOpen = true
    end
  end
  if not nvimTreeOpen then
    vim.cmd("wincmd " .. wincmd)
    return
  end
  vim.cmd("NvimTreeClose")
  vim.cmd("wincmd " .. wincmd)
  vim.cmd("NvimTreeOpen")
  vim.cmd("wincmd p")
end

function toggleDiff()
  local wins = vim.api.nvim_tabpage_list_wins(0)
  local isDiffOn = false
  for _, winId in pairs(wins) do
    local bufId = vim.api.nvim_win_get_buf(winId)
    isDiffOn = vim.api.nvim_win_get_option(winId, 'diff')
    if isDiffOn then
      break
    end
  end
  if isDiffOn then
    vim.cmd "diffoff!"
  else
    local wins = vim.api.nvim_tabpage_list_wins(0)
    local curWin = vim.api.nvim_get_current_win()
    for _, winId in pairs(wins) do
      local bufId = vim.api.nvim_win_get_buf(winId)
      local ft = vim.api.nvim_buf_get_option(bufId, 'ft')
      if ft ~= 'NvimTree' then
        vim.api.nvim_set_current_win(winId)
        vim.cmd "diffthis"
        -- vim.api.nvim_win_set_option(winId, 'diff', true)
      end
    end
    vim.api.nvim_set_current_win(curWin)
  end
end

nnoremap('<C-w>J', '<cmd>lua moveWindowPreservingNvimTree("J")<cr>')
nnoremap('<C-w>K', '<cmd>lua moveWindowPreservingNvimTree("K")<cr>')
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
    q = { '<cmd>q<cr>', 'close window' },
    w = { '<cmd>w<cr>', 'save' },
    d = { '<cmd>lua toggleDiff()<cr>', 'diff windows' },
    r = { '<cmd>r<cr>', 'rotate' },
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

vim.keymap.set('n', '<leader>gK', function ()
  local branch = vim.fn['fugitive#Head']()
  vim.cmd ( 'G push --set-upstream origin ' .. branch )
end)
vnoremap('<leader>gof', ":GBrowse<cr>")
nnoremap('<leader>gor', ':lua require("user/helpers").xdgOpen(require("user/helpers").getRemoteLink())<cr>')
nnoremap('<leader>gop', ':lua require("user/helpers").xdgOpen(require("user/helpers").getRemoteLink() .. "/-/pipelines")<cr>')
nnoremap('<leader>gom', ':lua require("user/helpers").xdgOpen(require("user/helpers").getRemoteLink() .. "/-/merge_requests")<cr>')

wk_reg {
  ['<leader>g'] = {
    name = 'git',
    t = { '<cmd>Telescope git_branches<cr>',   'branches' },
    g = { '<cmd>vert G | wincmd L<cr>',    'status' },
    f = { '<cmd>Telescope git_status<cr>', 'status - telescope' },

    b = { '<cmd>lua require"gitsigns".blame_line({full=true})<cr>',  'blame' },
    B = { '<cmd>lua require"gitsigns".blame_line({enter=true})<cr>', 'blame short' },
    p = { '<cmd>lua require"gitsigns".preview_hunk()<cr>',           'preview hunk' },
    u = { '<cmd>lua require"gitsigns".reset_hunk()<cr>:do User PachaHunkStatusChanged<cr>', 'undo hunk' },
    s = { '<cmd>lua require"gitsigns".stage_hunk()<cr>:do User PachaHunkStatusChanged<cr>', 'stage hunk' },
    v = { '<cmd>bel vert G log --oneline --graph --decorate --branches<cr>',                'commits' },
    V = { '<cmd>Telescope git_bcommits<cr>',                                                'commits - telescope' },

    h = { '<cmd>G pull<cr>',                'pull' },
    j = { '<cmd>G fetch --all --tags<cr>',         'fetch' },
    J = { '<cmd>G fetch --all --prune<cr>', 'fetch prune' },
    K = 'push (set-upstream)',
    L = { '<cmd>G push --force<cr>',        'push (force)' },
    l = { '<cmd>G push<cr>',                'push' },

    r = {
      name = 'rebase',
      i = { '<cmd>G rebase -i master<cr>',              'interactive' },
      a = { '<cmd>G rebase -i --autosquash master<cr>', 'interactive --autosquash' },
    },
    c = {
      name = 'commit',
      c = { '<cmd>G commit<cr>',                                  'commit' },
      f = { ':G commit --fixup <c-r>"<cr>'    ,                   'fixup' },
      a = { '<cmd>G commit --amend<cr>',                          'amend' },
      e = { '<cmd>G commit --amend --no-edit<cr>',                'amend (no-edit)' },
      r = { '<cmd>G commit --amend --no-edit --reset-author<cr>', 'amend (no-edit, reset-author)'},
    },
    o = {
      name = 'open remote',
      f = 'file',
      r = 'repo',
      p = 'pipelines',
      m = 'merge requests',
    },
    m = { '<cmd>G mergetool |Gvdiffsplit!<cr>', '3-way mergetool' },
  },
}

vnoremap('<leader>rs', ':lua require"caseswitcher".swapCaseOfVisualSelection("snake")<cr>')
vnoremap('<leader>rS', ':lua require"caseswitcher".swapCaseOfVisualSelection("snake-screaming")<cr>')
vnoremap('<leader>rc', ':lua require"caseswitcher".swapCaseOfVisualSelection("camel")<cr>')
vnoremap('<leader>rp', ':lua require"caseswitcher".swapCaseOfVisualSelection("pascal")<cr>')
vnoremap('<leader>rk', ':lua require"caseswitcher".swapCaseOfVisualSelection("kebab")<cr>')
vnoremap('<leader>rK', ':lua require"caseswitcher".swapCaseOfVisualSelection("kebab-screaming")<cr>')

wk_reg {
  ['<leader>r'] = {
    name = 'refactor',
    r = 'rename variable',
    t = { '<cmd>call formatting#toggle_multiline_args()<cr>', 'toggle multiline args' },
    s = { '<cmd>lua require"caseswitcher".swapCaseOfWordUnderCursor("snake")<cr><cmd>call repeat#set("<leader>rs")<cr>', 'turn snake_case' },
    S = { '<cmd>lua require"caseswitcher".swapCaseOfWordUnderCursor("snake-screaming")<cr><cmd>call repeat#set("<leader>rS")<cr>', 'turn SNAKE_CASE' },
    c = { '<cmd>lua require"caseswitcher".swapCaseOfWordUnderCursor("camel")<cr><cmd>call repeat#set("<leader>rc")<cr>', 'turn camelCase' },
    C = { '<cmd>lua require"caseswitcher".swapCaseOfWordUnderCursor("pascal")<cr><cmd>call repeat#set("<leader>rC")<cr>', 'turn CamelCase' },
    k = { '<cmd>lua require"caseswitcher".swapCaseOfWordUnderCursor("kebab")<cr><cmd>call repeat#set("<leader>rk")<cr>', 'turn kebab-case' },
    K = { '<cmd>lua require"caseswitcher".swapCaseOfWordUnderCursor("kebab-screaming")<cr><cmd>call repeat#set("<leader>rK")<cr>', 'turn KEBAB-CASE' },
  }
}

wk_reg {
  ['<leader>t'] = {
    name = 'tabs',
    d = { '<cmd>tcd %:h<cr>', 'switch tab working dir' },
    t = { '<cmd>tabnew<cr>', 'open tab' },
    c = { '<cmd>tabclose<cr>', 'close tab' },
    h = { '<cmd>tabprevious<cr><cmd>call repeat#set("<leader>th")<cr>', 'previous tab' },
    l = { '<cmd>tabnext<cr><cmd>call repeat#set("<leader>tl")<cr>', 'next tab' },
    k = { '<cmd>tabmove +1<cr><cmd>call repeat#set("<leader>tk")<cr>', 'move tab right' },
    j = { '<cmd>tabmove -1<cr><cmd>call repeat#set("<leader>tj")<cr>', 'move tab left' },
  }
}

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

-- Make commands
-- nnoremap('<leader>fk', '<cmd>!make up<cr>')
-- nnoremap('<leader>fj', '<cmd>!make down<cr>')
-- nnoremap('<leader>fl', '<cmd>!make run<cr>')
nnoremap('<leader>fh', '<cmd>lua require("nvim-treesitter-playground.hl-info").show_hl_captures()<cr>')
wk_reg {
  ["<leader>f"] = {
    name = "filetype specific",
    h = "print highlight under cursor",
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
    buf_nnoremap(fprefix .. 'T', '<cmd>GoTest<cr>')
    buf_nnoremap(fprefix .. 't', '<cmd>GoTestFile<cr>')
    buf_nnoremap(fprefix .. 'b', '<cmd>GoBuild<cr>')
    buf_nnoremap(fprefix .. 'B', '<cmd>call CustomGoBuild()<cr>')
    buf_nnoremap(fprefix .. 'f', '<cmd>GoFillStruct<cr>')
    buf_nnoremap(fprefix .. 'i', ':GoImpl <c-r><c-w><c-f>bldeguiw<c-c><c-e> *<c-r><c-f> ')
    buf_nnoremap(fprefix .. 'c', '<cmd>GoCoverageToggle<cr>')
    buf_nnoremap(fprefix .. 'l', '<cmd>GoMetaLinter --sort-results<cr>')
    buf_nnoremap(fprefix .. 'L', '<cmd>GoMetaLinter! --sort-results ./...<cr>')
    buf_nnoremap(fprefix .. 'a', '<cmd>GoAlternate<cr>')
  elseif ft == 'qf' then
    buf_nnoremap('dd', '<cmd>call setqflist(filter(getqflist(), {idx -> idx != line(".") - 1}), "r")<cr>')
  elseif ft == 'json' then
    buf_nnoremap(fprefix .. 'f', "<cmd>%! jq '.'<cr>")
  end
end

function CustomCtrlAHandler(direction)
  local line = vim.api.nvim_get_current_line()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local word = vim.fn.expand("<cword>")
  while string.sub(line, cursor[2]+1, cursor[2]+1) == " " do
    cursor[2] = cursor[2] + 1
    vim.cmd('normal! l')
  end
  local togglable = {
    { "yes", "no" },
    { "Yes", "No" },
    { "up", "down" },
    { "Up", "Down" },
    { "true", "false" },
    { "True", "False" },
    { "enable", "disable" },
    { "Enable", "Disable" },
    { "and", "or" },
    { "&&", "||" },
  }
  for _, pair in pairs(togglable) do
    if word == pair[1] then
      vim.cmd("normal! ciw" .. pair[2])
      return
    elseif word == pair[2] then
      vim.cmd("normal! ciw" .. pair[1])
      return
    end
  end

  if direction == 1 then
    vim.cmd("normal! ")
  else
    vim.cmd("normal! ")
  end
end
nnoremap("<C-a>", "<cmd>lua CustomCtrlAHandler(1)<cr>")
nnoremap("<C-x>", "<cmd>lua CustomCtrlAHandler(-1)<cr>")

return M

