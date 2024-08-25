require "ui.winbar"
require "ui.tabline"

local h = require "ui.helpers"

vim.o.winbar = "%{%v:lua.require('ui.winbar').getMyWinbar()%}"
vim.o.tabline= "%{%v:lua.require('ui.tabline').myTabline()%}"
vim.o.showtabline = 2

local colors = {

  Cyan = "#4FB8CC",
  DarkCyan = "#008EC4",

  LightGreen = "#a6e5b2",
  DarkGreen = "#5FD7A7",

  Red = "#ec7f8e",
  Yellow = "#F4B047",

  BlueAccent = "#008EC4",
  RedAccent = "#E32791",

  -- "#20BBFC",
  -- "#20A5BA",
  -- "#b6d6fd",
  -- "#f7db91",
  -- "#ebb1aa",
  -- "#2C81FB",
}

for name, value in pairs(colors) do
  h.create_hl(name, { fg = value })
end



local customize_color_scheme = function ()
  local normal = h.get_hl("Normal")
  local tabline = h.get_hl("TabLine")
  local winbar = h.get_hl("WinBar")

  h.create_hl("P_Split", { bg = tabline.bg, fg = normal.bg })

  h.create_hl("NvimDarkGrey1.5", { bg = "#111317" })
  h.create_hl("NvimDarkGrey2.5", { bg = "#17181a" })
  h.create_hl("NvimDarkGrey2.75", { bg = "#17181a" })

  h.link("WinSeparator", "P_Split")
  h.link("ColorColumn", "NvimDarkGrey1.5")

  -- register tabline hl groups
  h.create_hl("TabLineSelBold", h.extend("TablineSel", { bold = true, cterm = { bold = true } }))
  h.create_hl("TabLineSel", h.extend("TablineSel", { bold = false, cterm = { bold = false } }))
  h.create_hl("TabLineDivider", h.extend("TabLine", { fg=normal.bg }))
  h.create_hl("TabLineDividerSelected", { bg = tabline.bg, fg=normal.bg })

  h.link("Directory", "Cyan")
  h.link("Question", "Cyan")
  h.link("MoreMsg", "Cyan")

  h.link("DiffText", "Cyan")
  h.link("DiffRemove", "Red")
  h.link("DiffDelete", "Red")
  h.link("DiffChange", "Yellow")
  h.link("DiffAdd", "DarkGreen")

  h.link("Removed", "Red")
  h.link("Changed", "Yellow")
  h.link("Added", "DarkGreen")

  h.link("Constant", "Cyan")

  h.link("Constant", "Red")
  h.link("Special", "Red")

  h.link("DiagnosticError", "Red")
  h.link("DiagnosticWarn", "Yellow")
  h.link("DiagnosticInfo", "DarkCyan")
  h.create_hl("DiagnosticHint", { fg = "#b6d6fd" })
  h.link("DiagnosticOk", "DarkGreen")

  h.link("Statement", "DarkCyan")
  h.link("String", "LightGreen")
  h.link("Type", "Cyan")
  h.link("Function", "Cyan")
  h.create_hl("Identifier", { fg = normal.fg })

  h.link("Todo", "Cyan")

  h.create_hl("CurSearch", { bg="#E32791", fg=normal.fg })
  h.create_hl("Search", { bg="#008EC4", fg=normal.fg })

end

customize_color_scheme()

vim.api.nvim_create_autocmd("ColorScheme", { callback = customize_color_scheme })
