local wk = require'which-key'

wk.setup {
  notify = false,
  plugins = {
    marks = false, -- shows a list of your marks on ' and `
    registers = false, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    spelling = {
      enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    presets = {
      operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
      motions = false, -- adds help for motions
      text_objects = false, -- help for text objects triggered after entering an operator
      windows = false, -- default bindings on <c-w>
      nav = false, -- misc bindings to work with windows
      z = false, -- bindings for folds, spelling and others prefixed with z
      g = false, -- bindings for prefixed with g
    },
  },
  win = {
    no_overlap = false,
    bo = {
      -- spell = false,
    },
    wo = {
      winblend = 15
    }
  },
  -- sort = 'manual',
  layout = {
    height = { min = 4 }, -- min and max height of the columns
    width = { min = 20 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
  },
  keys = {
    scroll_down = "<c-d>", -- binding to scroll down inside the popup
    scroll_up = "<c-u>", -- binding to scroll up inside the popup
  },
  triggers = {
    { "<leader>", mode = { "n", "v" } },
    { "<F9>" },
    { "<F3>" },
  },
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
    mappings = false,
    colors = false,
    -- keys = {
    --   Up = " ",
    --   Down = " ",
    --   Left = " ",
    --   Right = " ",
    --   C = "󰘴 ",
    --   M = "󰘵 ",
    --   D = "󰘳 ",
    --   S = "󰘶 ",
    --   CR = "󰌑 ",
    --   Esc = "󱊷 ",
    --   ScrollWheelDown = "󱕐 ",
    --   ScrollWheelUp = "󱕑 ",
    --   NL = "󰌑 ",
    --   BS = "󰁮",
    --   Space = "󱁐 ",
    --   Tab = "󰌒 ",
    --   F1 = "󱊫",
    --   F2 = "󱊬 ",
    --   F3 = "󱊭 ",
    --   F4 = "󱊮 ",
    --   F5 = "󱊯 ",
    --   F6 = "󱊰 ",
    --   F7 = "󱊱 ",
    --   F8 = "󱊲 ",
    --   F9 = "󱊳 ",
    --   F10 = "󱊴",
    --   F11 = "󱊵",
    --   F12 = "󱊶",
    -- }
  },
  show_help = false, -- show a help message in the command line for using WhichKey
  show_keys = false, -- show the currently pressed key and its label as a message in the command line
}
