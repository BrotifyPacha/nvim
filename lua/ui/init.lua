require "ui.winbar"
require "ui.tabline"

local h = require "ui.helpers"

vim.o.winbar = "%{%v:lua.require('ui.winbar').getMyWinbar()%}"
vim.o.tabline= "%{%v:lua.require('ui.tabline').myTabline()%}"
vim.o.showtabline = 2

local color = {
  "#20BBFC",
  "#008EC4",
  "#2C81FB",
  "#E32791",
  "#20A5BA",
  "#4FB8CC",

  "#a6e5b2",
  "#a3d6fa",
  "#f7db91",
  "#ebb1aa",
  "#ec7f8e",
  "#E32791",
}


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

  h.create_hl("DiffText", { fg = "#4FB8CC" })
  h.create_hl("DiffRemove", { fg = "#ec7f8e" })
  h.create_hl("DiffDelete", { fg = "#ec7f8e" })
  h.create_hl("DiffChange", { fg = "#F4B047" })
  h.create_hl("DiffAdd", { fg = "#5FD7A7" })

  h.create_hl("Removed", { fg = "#ec7f8e" })
  h.create_hl("Changed", { fg = "#F4B047" })
  h.create_hl("Added", { fg = "#5FD7A7" })

  h.create_hl("Constant", { fg = "#4FB8CC" })

  h.create_hl("Constant", { fg = "#ec7f8e" })
  h.create_hl("Special", { fg = "#ec7f8e" })

  h.create_hl("DiagnosticError", { fg = "#ec7f8e" })
  h.create_hl("DiagnosticWarn", { fg = "#F4B047" })
  h.create_hl("DiagnosticInfo", { fg = "#008EC4" })
  h.create_hl("DiagnosticHint", { fg = "#b6d6fd" })
  h.create_hl("DiagnosticOk", { fg = "#5FD7A7" })

  h.create_hl("Statement", { fg = "#008EC4" })
  h.create_hl("String", { fg = "#a6e5b2" })
  h.create_hl("Type", { fg = "#4FB8CC" })
  h.create_hl("Function", { fg = "#4FB8CC" })
  h.create_hl("Identifier", { fg = normal.fg })

  h.create_hl("Todo", { fg = "#4FB8CC" })

  h.create_hl("CurSearch", { bg="#E32791", fg=normal.fg })
  h.create_hl("Search", { bg="#008EC4", fg=normal.fg })

end

customize_color_scheme()

vim.api.nvim_create_autocmd("ColorScheme", { callback = customize_color_scheme })
