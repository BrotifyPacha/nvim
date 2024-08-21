local M = {}

local h = require "ui.helpers"

function M.getMyWinbar()
  local devicons, err = require'nvim-web-devicons'
  local icon = nil
  local icon_highlight = nil

  local win_id = vim.api.nvim_get_current_win()
  local buf_id = vim.api.nvim_win_get_buf(win_id)

  if err == nil then
    icon, icon_highlight = devicons.get_icon_by_filetype(vim.bo.ft)
  end

  local winbarHL = h.get_hl("WinBar")
  h.create_hl("WinbarErr", h.extend("ErrorMsg", { bg = winbarHL.bg }))
  h.create_hl("WinbarNormal", h.extend("Normal", { bg = winbarHL.bg }))
  h.create_hl("WinbarNone", h.extend("FoldColumn", { bg = winbarHL.bg }))

  local fname = vim.fn.expand('%')
  local buftype = vim.bo.buftype
  local highlight = "WinbarNone"
  if fname == '' then
    if buftype ~= '' and buftype == 'quickfix' then
      local title = vim.fn.getqflist({title = 1}).title
      icon = ''
      if string.match(title, '.+fail.+') then
        highlight = 'WinbarErr'
        icon_highlight = highlight
      end
      fname = '%#' .. highlight .. '%*' .. title .. '%*%#WinbarNone# - Quickfix%*'
    else
      highlight = "WinbarNone"
      icon_highlight = highlight
      fname = '%#'.. highlight .. '#' .. '-No-name-' .. '%*'
    end
  elseif buftype == 'terminal' then
    icon = ''
    fname = 'Terminal'
  end

  icon = '%#' .. icon_highlight .. '#' .. icon .. '%*'

  local output = {
    ' ',
    -- '['.. win_id .. ', '.. buf_id ..'] ',
    icon,
    fname,
    '%#WinbarNone%',
  }

  return table.concat(output, ' ')
end

return M
