local M = {}

local h = require "ui.helpers"

function M.getMyWinbar()
  local devicons, err = require'nvim-web-devicons'
  local icon = nil
  local icon_highlight = nil

  if err == nil then
    icon, icon_highlight = devicons.get_icon_by_filetype(vim.bo.ft)
  end

  local winbarHL = h.get_hl("WinBar")
  h.create_hl("WinbarErr", h.extend("ErrorMsg", { bg = winbarHL.bg }))
  h.create_hl("WinbarNormal", h.extend("Normal", { bg = winbarHL.bg }))
  h.create_hl("WinbarNone", h.extend("FoldColumn", { bg = winbarHL.bg }))

  local tab_id = vim.api.nvim_get_current_tabpage()
  local cwds = {}
  for _, win_id in ipairs(vim.api.nvim_tabpage_list_wins(tab_id)) do
    local cwd = vim.fn.getcwd(win_id, tab_id)
    if not vim.tbl_contains(cwds, cwd) then
      cwds[#cwds+1] = cwd
    end
  end

  local fname = vim.fn.expand('%')

  for _, wd in ipairs(cwds) do
    local relname = vim.fs.relpath(wd, fname)
    if relname ~= nil and relname ~= "." then
      fname = relname
    end
  end

  local buftype = vim.bo.buftype
  local highlight = "WinbarNone"
  if fname == '' then
    if buftype ~= '' and buftype == 'quickfix' then
      local title = vim.fn.getqflist({title = 1}).title
      icon = '󰉺'
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
  else
    if buftype == 'terminal' then
      icon = ''
      fname = 'Terminal'
    else
      local win_cwd = vim.fn.getcwd(vim.api.nvim_get_current_win())
      if #cwds > 1 then
        fname = "(" .. vim.fs.basename(win_cwd) .. ") " .. fname
      end
    end
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
