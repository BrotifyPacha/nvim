local M = {}
local wk_reg = require 'which-key'.add

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

-- Telescope
nnoremap('<C-p>', '<cmd>Telescope find_files<cr>')
nnoremap('<C-g>', '<cmd>Telescope live_grep_args<cr>')
nnoremap('<C-h>', '<cmd>Telescope git_status<cr>')
nnoremap('-', '<cmd>Telescope current_buffer_fuzzy_find<cr>')

-- camelCaseWordTestingArt3Times
vim.api.nvim_set_keymap('n', '<A-w>', ':call search("[A-Z]")<cr>', { expr = false, noremap = true, nowait = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-b>', ':call search("[A-Z]", "b")<cr>', { expr = false, noremap = true, nowait = true, silent = true })
onoremap('ic', "<cmd>lua require 'mytextobj'.camelCaseTextObj()<cr>")


-- Surround extension
nnoremap('dsf', '<cmd>call formatting#delete_surrounding_func()<cr>')
nnoremap('csf', '<cmd>call formatting#change_surrounding_func("")<cr>')

-- Unimpared extension
nnoremap('[[', ':tabprevious<cr>')
nnoremap(']]', ':tabnext<cr>')
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

nnoremap('cw', 'ciw')
nnoremap('vv', '^v$h')
nnoremap('Y', 'yg_')
vnoremap('*', "y/\\V<C-r>=escape(@\", '\\/')<cr><cr>")
vim.api.nvim_set_keymap("s", "*", "a<BS>*", { noremap = true })

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
  { "F1", group = "Change working directory" },
  {  "F1<F1>", '<cmd>lua require"user.helpers".PickWorkingDir("tcd", '.. dirs ..')<cr>', desc = "workspace/plugins", },
  {  "F1n"   , ':tcd ~/.config/nvim | e $MYVIMRC <cr>', desc = "neovim config"},
  {  "F1l"   , '<cmd>lua require"user.helpers".PickWorkingDir("lcd", '.. dirs ..')<cr>', desc = "workspace/plugins (local)", },
  {  "F1K"   , '<cmd>lua require"user.helpers".PickWorkingDir("tcd", {'.. k8sMigratorDir ..'})<cr>', desc = "k8s-migrator", },
  {  "F1k"   , '<cmd>lua require"user.helpers".PickWorkingDir("lcd", {'.. k8sMigratorDir ..'})<cr>', desc = "k8s-migrator (local)", },
  {  "F1C"   , '<cmd>lua require"user.helpers".PickWorkingDir("tcd", {'.. configsDir ..'})<cr>', desc = "configs", },
  {  "F1c"   , '<cmd>lua require"user.helpers".PickWorkingDir("lcd", {'.. configsDir ..'})<cr>', desc = "configs (local)", },
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
nnoremap('<F9><F10>', '<cmd>lua require"terminal".open_new_terminal()<cr>')
nnoremap('<F9>', '<cmd>WhichKey F9<cr>')

wk_reg {
  { "F9", group = "terminal" },
  { "F9<F9>", desc = "open/next terminal" },
  { "F9<F10>", desc = "open new terminal" },
}

-- Terminal mode key maps
tnoremap('<Esc>', '<C-\\><C-n>')

-- Insert mode key maps
inoremap('<C-f>', '<C-x><C-f>')
inoremap('<C-l>', '<C-x><C-l>')

inoremap('<down>', '<-')
inoremap('<up>', '->')

inoremap('<C-r>c', '<C-r>=trim(v:lua.require(\'user.helpers\').getStdoutOf(\'kcolorchooser --print 2>/dev/null\')[0])<cr>')
inoremap('<C-r>d', './<C-r>=expand("%:h")<cr>')
inoremap('<C-r>p', './<C-r>=expand("%")<cr>')
inoremap('<C-r>P', '<C-r>=expand("%:p")<cr>')
inoremap('<C-r>f', '<C-r>=expand("%:t:r")<cr>')
inoremap('<C-r>F', '<C-r>=expand("%:t")<cr>')

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
nnoremap('<leader>E', "<cmd>NvimTreeFindFile<cr>")
nnoremap('<leader>l', "<C-w>l")
nnoremap('<leader>h', "<C-w>h")
nnoremap('<leader>j', "<C-w>j")
nnoremap('<leader>k', "<C-w>k")
nnoremap('<leader>H', "<cmd>vsplit<cr>")
nnoremap('<leader>J', "<cmd>bel split<cr>")
nnoremap('<leader>K', "<cmd>split<cr>")
nnoremap('<leader>L', "<cmd>vert bel split<cr>")

nnoremap('<leader>qc', ':cclose<cr>')

wk_reg {
  { "<leader><space>", desc = "Goto next <-->" },
  { "<leader>e", desc = "File explorer" },
  { "<leader>E", desc = "Find file in explorer" },
  { "<leader>H", hidden = true },
  { "<leader>J", hidden = true },
  { "<leader>K", hidden = true },
  { "<leader>L", hidden = true },
  { "<leader>h", hidden = true },
  { "<leader>j", hidden = true },
  { "<leader>k", hidden = true },
  { "<leader>l", hidden = true },

  { "<leader>q", group = "quickfix" },
  { "<leader>qc", desc = 'close'},

  { "<leader>d", group = "debug" },
  { "<leader>da", desc = "start with args" },
  { "<leader>dc", desc = "run to cursor" },
  { "<leader>dd", desc = "toggle breakpoint" },
  { "<leader>de", desc = "eval under cursor" },
  { "<leader>df", desc = "toggle If breakpoint" },
  { "<leader>dp", desc = "repeat previous run" },
  { "<leader>ds", desc = "start/continue" },
  { "<leader>dt", desc = "run tests" },

  { "<leader>t", group = "tabs" },
  { "<leader>tc", "<cmd>tabclose<cr>", desc = "close tab" },
  { "<leader>td", "<cmd>tcd %:h<cr>", desc = "switch tab working dir" },
  { "<leader>th", '<cmd>tabprevious<cr><cmd>call repeat#set("<leader>th")<cr>', desc = "previous tab" },
  { "<leader>tj", '<cmd>tabmove -1<cr><cmd>call repeat#set("<leader>tj")<cr>', desc = "move tab left" },
  { "<leader>tk", '<cmd>tabmove +1<cr><cmd>call repeat#set("<leader>tk")<cr>', desc = "move tab right" },
  { "<leader>tl", '<cmd>tabnext<cr><cmd>call repeat#set("<leader>tl")<cr>', desc = "next tab" },
  { "<leader>tt", "<cmd>tabnew<cr>", desc = "open tab" },
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
nnoremap('<leader>wd' , '<cmd>lua toggleDiff()<cr>')
wk_reg {
  { "<leader>w", group = "windows" },
  { "<leader>wF", desc = "make window Floating" },
  { "<leader>wd", desc = "diff windows" },
  { "<leader>wf", desc = "select Floating" },
  { "<leader>wh", desc = "move float left" },
  { "<leader>wj", desc = "move float down" },
  { "<leader>wk", desc = "move float top" },
  { "<leader>wl", desc = "move float right" },
  { "<leader>wq", "<cmd>q<cr>", desc = "close window" },
  { "<leader>wr", "<cmd>r<cr>", desc = "rotate" },
  { "<leader>ww", "<cmd>w<cr>", desc = "save" },
}

vim.keymap.set('n', '<leader>gK', function ()
  local branch = vim.fn['fugitive#Head']()
  vim.cmd ( 'G push --set-upstream origin ' .. branch )
end)
vnoremap('<leader>gof', ":GBrowse<cr>")
nnoremap('<leader>gor', ':lua require("user/helpers").xdgOpen(require("user/helpers").getRemoteLink())<cr>')
nnoremap('<leader>gop', ':lua require("user/helpers").xdgOpen(require("user/helpers").getRemoteLink() .. "/-/pipelines")<cr>')
nnoremap('<leader>gom', ':lua require("user/helpers").xdgOpen(require("user/helpers").getRemoteLink() .. "/-/merge_requests")<cr>')

function viewGitHistory()
  vim.cmd [[ bel vert G log --oneline --graph --branches --decorate ]]
  vim.fn.search("(HEAD ->")
end

wk_reg {
  { "<leader>g", group = "git" },
  { "<leader>gt", "<cmd>Telescope git_branches<cr>", desc = "branches" },
  { "<leader>gg", "<cmd>vert G | wincmd L<cr>", desc = "status" },
  { "<leader>gf", "<cmd>Telescope git_status<cr>", desc = "status - telescope" },

  { "<leader>gB", '<cmd>lua require"gitsigns".blame_line({enter=true})<cr>', desc = "blame short" },
  { "<leader>gb", '<cmd>lua require"gitsigns".blame_line({full=true})<cr>', desc = "blame" },

  { "<leader>gh", "<cmd>G pull<cr>", desc = "pull" },
  { "<leader>gj", "<cmd>G fetch --all --tags<cr>", desc = "fetch" },
  { "<leader>gJ", "<cmd>G fetch --all --prune<cr>", desc = "fetch prune" },
  { "<leader>gK", desc = "push (set-upstream)" },
  { "<leader>gL", "<cmd>G push --force-with-lease<cr>", desc = "push (force)" },
  { "<leader>gl", "<cmd>G push<cr>", desc = "push" },

  { "<leader>gV", "<cmd>Telescope git_bcommits<cr>", desc = "commits - telescope" },
  { "<leader>gv", "<cmd>lua viewGitHistory()<cr>", desc = "commits" },

  { "<leader>gc", group = "commit" },
  { "<leader>gca", "<cmd>G commit --amend<cr>", desc = "amend" },
  { "<leader>gcc", "<cmd>G commit<cr>", desc = "commit" },
  { "<leader>gce", "<cmd>G commit --amend --no-edit<cr>", desc = "amend (no-edit)" },
  { "<leader>gcf", ':G commit --fixup <c-r>"<cr>', desc = "fixup" },
  { "<leader>gcr", "<cmd>G commit --amend --no-edit --reset-author<cr>", desc = "amend (no-edit, reset-author)" },

  { "<leader>gp", '<cmd>lua require"gitsigns".preview_hunk()<cr>', desc = "preview hunk" },
  { "<leader>gs", '<cmd>lua require"gitsigns".stage_hunk()<cr>:do User PachaHunkStatusChanged<cr>', desc = "stage hunk" },
  { "<leader>gu", '<cmd>lua require"gitsigns".reset_hunk()<cr>:do User PachaHunkStatusChanged<cr>', desc = "undo hunk" },

  { "<leader>gr", group = "rebase" },
  { "<leader>gra", "<cmd>G rebase -i --autosquash master<cr>", desc = "interactive --autosquash" },
  { "<leader>gri", "<cmd>G rebase -i master<cr>", desc = "interactive" },

  { "<leader>go", group = "open remote" },
  { "<leader>gor", desc = "repo" },
  { "<leader>gop", desc = "pipelines" },
  { "<leader>gom", desc = "merge requests" },
  { "<leader>gof", desc = "file" },

  { "<leader>gm", "<cmd>G mergetool |Gvdiffsplit!<cr>", desc = "3-way mergetool" },
}

vnoremap('<leader>rs', ':lua require"caseswitcher".swapCaseOfVisualSelection("snake")<cr>')
vnoremap('<leader>rS', ':lua require"caseswitcher".swapCaseOfVisualSelection("snake-screaming")<cr>')
vnoremap('<leader>rc', ':lua require"caseswitcher".swapCaseOfVisualSelection("camel")<cr>')
vnoremap('<leader>rp', ':lua require"caseswitcher".swapCaseOfVisualSelection("pascal")<cr>')
vnoremap('<leader>rk', ':lua require"caseswitcher".swapCaseOfVisualSelection("kebab")<cr>')
vnoremap('<leader>rK', ':lua require"caseswitcher".swapCaseOfVisualSelection("kebab-screaming")<cr>')

wk_reg {
  { "<leader>r", group = "refactor" },
  { "<leader>rr", desc = "rename variable" },
  { "<leader>rt", "<cmd>call formatting#toggle_multiline_args()<cr>", desc = "toggle multiline args" },
  { "<leader>rC", '<cmd>lua require"caseswitcher".swapCaseOfWordUnderCursor("pascal")<cr><cmd>call repeat#set("<leader>rC")<cr>', desc = "turn CamelCase" },
  { "<leader>rK", '<cmd>lua require"caseswitcher".swapCaseOfWordUnderCursor("kebab-screaming")<cr><cmd>call repeat#set("<leader>rK")<cr>', desc = "turn KEBAB-CASE" },
  { "<leader>rS", '<cmd>lua require"caseswitcher".swapCaseOfWordUnderCursor("snake-screaming")<cr><cmd>call repeat#set("<leader>rS")<cr>', desc = "turn SNAKE_CASE" },
  { "<leader>rc", '<cmd>lua require"caseswitcher".swapCaseOfWordUnderCursor("camel")<cr><cmd>call repeat#set("<leader>rc")<cr>', desc = "turn camelCase" },
  { "<leader>rk", '<cmd>lua require"caseswitcher".swapCaseOfWordUnderCursor("kebab")<cr><cmd>call repeat#set("<leader>rk")<cr>', desc = "turn kebab-case" },
  { "<leader>rs", '<cmd>lua require"caseswitcher".swapCaseOfWordUnderCursor("snake")<cr><cmd>call repeat#set("<leader>rs")<cr>', desc = "turn snake_case" },
}

vim.cmd
[[
augroup pacha_filetype_mappings
autocmd!
autocmd FileType * lua require'user.mappings'.set_filetype_specific_mappings()
augroup end
]]

nnoremap('<leader>fh', '<cmd>TSHighlightCapturesUnderCursor<cr>')
wk_reg {
  { "<leader>f", group = "filetype specific" },
  { "<leader>fh", desc = "highlight under cursor" }
}

wk_reg {
  { "go", group = "go" },
  { "got", desc = 'test file' },
  { "goT", desc = "test project" },
  { "gob", desc = 'build' },
  { "goB", desc = 'build project' },
  { "gof", desc = 'fill struct' },
  { "goi", desc = 'implement' },
  { "goc", desc = 'toggle coverage' },
  { "gol", desc = 'lint' },
  { "goL", desc = 'lint project' },
  { "goa", desc = 'jump to tests and back' },
  { "gom", desc = 'mock interface' },

  { "vim", group = "vim" },
  { "vimh", desc = "print highlight under cursor" },
  { "vims", desc = "save & source" },

  { "lua", group = "lua" },
  { "luah", desc = "print highlight under cursor" },
  { "luas", desc = "save & source" },

  { "markdown", group = "markdown" },
  { "markdownp", desc = "preview" },

  { "json", group = "json" },
  { "jsonp", desc = "format" },
}


function M.set_filetype_specific_mappings()
  local ft = vim.api.nvim_buf_get_option(0, 'ft')
  local fprefix = '<leader>f'

  buf_nnoremap(fprefix, ':WhichKey ' .. ft .. '<cr>')

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
    buf_nnoremap(fprefix .. 'm', ':lua MockInterfaceUnderCusor()<cr>')

    vim.keymap.set('n', fprefix .. 'gm', require'helpers.go-dependency-pickers'.live_grep, { desc = 'Live grep go dependencies' })

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

