
vim.g.mapleader = ' '

vim.opt.signcolumn = 'auto:2-9'
vim.opt.number = true
vim.opt.colorcolumn = '80'
vim.opt.wrap = false

vim.opt.linebreak = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.scrolloff = 4

vim.opt.listchars = {
  space = '.',
  eol   = '$',
  tab   = '>-',
  trail = '~',
  nbsp  = '+'
}
vim.opt.showmatch = true

vim.opt.mouse = 'a'
vim.opt.hidden = true
vim.opt.path:append('**')
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.swapfile = false
vim.opt.regexpengine = 1
vim.opt.diffopt:append('vertical')
vim.opt.virtualedit = 'block'

-- vim.opt.grepprg = grep\ -Rin\ $*\ --exclude-dir={.git,vendor,logs}\ /dev/null

vim.opt.wildmenu = true
vim.opt.wildoptions:append('pum')
vim.opt.inccommand = 'nosplit'
vim.opt.termguicolors = true

-- Update time for gitsigns
vim.opt.updatetime = 100

vim.opt.bg = 'dark'

vim.opt.fillchars = {
  fold  = '-',
  vert  = ' ',
  vertleft = ' ',
  vertright = ' ',
  verthoriz = ' ',
  horizup = ' ',
  horizdown = '▀',
  horiz = '▀',
  diff = '╱',
}
vim.opt.foldlevel = 99
vim.opt.foldminlines = 3
-- vim.opt.foldopen = block,hor,insert,jump,mark,percent,quickfix,search,tag,undo

vim.opt.spelllang = { 'en', 'ru' }

vim.opt.langmap = {
  'ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯХЪЖБЮЁ;ABCDEFGHIJKLMNOPQRSTUVWXYZ{}:<>~,',
  "фисвуапршолдьтщзйкыегмцчняхъэюё;abcdefghijklmnopqrstuvwxyz[]'.`",
  'Э;\\"',
  'ж;\\;',
  'б;\\,',
  '№;#'
}

vim.opt.laststatus = 3
vim.opt.showmode = false

vim.opt.sessionoptions = {
  'blank',
  'buffers',
  'curdir',
  'help',
  -- 'globals',
  -- 'localoptions',
  -- 'options',
  -- 'resize',
  'winsize',
  'tabpages',
}

-- Plugin specific options
vim.g.PHP_vintage_case_default_indent = true

