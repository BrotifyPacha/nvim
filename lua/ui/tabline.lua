local M = {}

function M.myTabline()
  local tabs = {}
  local selectedTabNumber = vim.fn.tabpagenr()
  for index, id in ipairs(vim.api.nvim_list_tabpages()) do

    local isSelected = index == selectedTabNumber

    local tabLabel = M.myTabLabel(isSelected, index, id)
    local tabSelector = '%' .. index .. 'T'
    local tabCloser = '%' .. index  .. 'X '
    local tabButton = tabSelector .. tabLabel .. ' ' .. tabCloser

    local sep_highlight = '%#TabLineDivider#'
    local sep = '│'
    if index + 1 == vim.fn.tabpagenr() then
      sep_highlight = '%#TabLineDividerSelected#'
      sep = '▐'
    else if index == vim.fn.tabpagenr() and index ~= vim.fn.tabpagenr('$') then
      sep_highlight = '%#TabLineDividerSelected#'
      sep = '▌'
    else if index == vim.fn.tabpagenr('$') then
      sep = ''
    end
      end
    end
    tabs[#tabs+1] = tabButton .. sep_highlight .. sep
  end

  local tabLine = table.concat(vim.tbl_flatten(tabs), "" )
  -- print(tabLine)
  return tabLine
end

function M.myTabLabel(tabSelected, tabNumber, tabId)

  local cwds = M.getUniqueCWDsOnTab(tabNumber, tabId)

  local selectedCwd = vim.fn.getcwd(0, tabNumber)
  for i, cwd in ipairs(cwds) do
    local tab_highlight = M.getTabHighlight(tabSelected, cwd == selectedCwd)
    cwd = vim.fn.substitute(cwd, '.*[/\\\\]', '', '')
    cwds[i] = tab_highlight .. " " .. cwd
  end
  return table.concat(vim.tbl_flatten(cwds), " /")
end

function M.getTabHighlight(tabSelected, dirIsCurrentDir)
  if not tabSelected then
    return '%#TabLine#'
  end

  if dirIsCurrentDir then
    return '%#TabLineSelBold#'
  end

  return '%#TabLineSel#'
end

function M.getUniqueCWDsOnTab(tabNumber, tabId)
  local cwds = {}
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabId)) do
    local cwd = vim.fn.getcwd(win, tabNumber)
    if not vim.tbl_contains(cwds, cwd) then
      cwds[#cwds+1] = cwd
    end
  end
  return cwds
end

return M
