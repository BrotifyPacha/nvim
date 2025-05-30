local M = {}

function M.reload(m)
  package.loaded[m] = nil
  return require(m)
end

function M.visualExec(func)
  if vim.fn.mode() ~= 'v' or vim.fn.mode() ~= 'V' then
    vim.api.nvim_exec([[
            normal! gv
            lua ]] .. func
      , false)
  end
end

function M.getRemoteLink()
  local handle = io.popen('git remote -v | head -n 1 | awk \'{print $2}\' | sed s/\\r$// ')
  local remote = handle:read("*l")
  handle:close()
  remote = string.gsub(remote, '^http://', '')
  remote = string.gsub(remote, '^https://', '')
  remote = string.gsub(remote, '^ssh://', '')
  remote = string.gsub(remote, 'git@', '')
  remote = string.gsub(remote, 'ssh%.', '')
  remote = string.gsub(remote, '%.git', '')
  remote = string.gsub(remote, ':', '/')
  return 'http://' .. remote
end

function M.xdgOpen(arg)
  os.execute('xdg-open "' .. arg .. '"')
end

function M.winOpenFloat(buf_id)
  local options = {
    relative='editor',
    row=(vim.go.lines/3),
    col=(vim.go.columns/3),
    width=math.floor(vim.go.columns/3),
    height=math.floor(vim.go.lines/3),
    border='single',
  }
  vim.api.nvim_win_set_config(buf_id, options)
end

function M.winMoveFloat(delta_row, delta_col)
  local win_id = 0
  local current = vim.api.nvim_win_get_config(win_id)
  if current.relative == '' then
    return
  end
  local options = {
    row = current.row[false] + delta_row,
    col = current.col[false] + delta_col,
  }
  vim.api.nvim_win_set_config(win_id, vim.tbl_extend('force', current, options))
end

function M.winSelectFloat()
  for _, win_id in pairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win_id).relative ~= '' then
      vim.api.nvim_set_current_win(win_id)
    end
  end
end

function M.GetGPS()
  local class_highlight     = '%#Type#'
  local container_highlight = class_highlight
  local method_highlight    = '%#Function#'
  local function_highlight  = '%#Special#'

  local sequence_highlight  = class_highlight
  local mapping_highlight   = function_highlight
  local stiring_highlight   = '%#String#'

  local gps = require'nvim-gps'
  local gps_data_func = gps.get_data
  local _, gps_data = pcall(gps_data_func)

  if gps ~= nil and gps_data ~= nil and gps.is_available() then
    local output = {}
    for _, item in pairs(gps_data) do
      local highlight = nil
      if item.type == 'class-name' then
        highlight = class_highlight
      elseif item.type == 'container-name' then
        highlight = container_highlight
      elseif item.type == 'method-name' then
        highlight = method_highlight
      elseif item.type == 'function-name' then
        highlight = function_highlight
      elseif item.type == 'sequence-name' then
        highlight = sequence_highlight
      elseif item.type == 'mapping-name' then
        highlight = mapping_highlight
      elseif item.type == 'string-name' then
        highlight = stiring_highlight
      else
        highlight = '%#Normal#'
      end
      table.insert(
        output,
        {
          preformatted = highlight .. item.icon .. '%*' .. '%#Folded#' .. item.text .. '%*',
          icon = item.icon,
          text = item.text
        }
      )
    end
    return output
  end
  return {}
end

-- test_items = {
--   "./cmd/a",
--   "./cmd/b",
--   "./cmd/c",
--   "./cmd/d",
--   "./cmd/grafana-itc-bridge",
--   "./cmd/grafana-itc-bridge/main.go",
--   "./scripts/main.go",
--   "./scripts",
-- }

function M.sort_entrypoints(entry_points)
  table.sort(
    entry_points,
    function (a, b)
      local cmd_pattern = "^./cmd/"
      local go_file_pattern = "%.go$"
      local a_val, b_val = 0, 0

      local sort_test = function (test, cost)
        if test then
          return cost
        end
        return 0
      end

      a_val = a_val + sort_test(a:find(cmd_pattern) ~= nil, 100)
      b_val = b_val + sort_test(b:find(cmd_pattern) ~= nil, 100)

      a_val = a_val + sort_test(a:find(go_file_pattern) ~= nil, -10)
      b_val = b_val + sort_test(b:find(go_file_pattern) ~= nil, -10)

      a_val = a_val + sort_test(a < b, 1)
      b_val = b_val + sort_test(a > b, 1)

      print(a, b, a_val, b_val)
      -- if a:sub(-#find) == find then
      --   return a:
      -- end
      return a_val > b_val
    end
  )
end

function M.PickGoMainFile()
  local results = io.popen("rg '^\\s*func main()' --glob '*.go' --vimgrep")
  local items = {}

  for filename in results:lines() do
    local item = vim.split(filename, ':')
    local fullpath = item[1]

    local path_segments = vim.split(fullpath, "/", { trimempty = true })
    table.remove(path_segments, #path_segments)
    local pkg = table.concat(path_segments, "/")
    if pkg == "" then
      pkg = "."
    end

    items[#items+1] = "./" .. pkg
    items[#items+1] = fullpath

  end

  M.sort_entrypoints(items)

  if #items == 1 then
    return items[1]
  end

  local selected = nil
  vim.ui.select(items, {
    prompt = 'Select go file:'
  }, function (choice)
      selected = choice
  end)
  vim.api.nvim_command('redraw!')
  return selected
end

function M.PickWorkingDir(cmd, dirs)
  print(vim.inspect(dirs))
  local actions = require "telescope.actions"
  local actions_state = require "telescope.actions.state"
  local pickers = require "telescope.pickers"
  local finders = require "telescope.finders"
  local sorters = require "telescope.sorters"
  local dropdown = require "telescope.themes".get_dropdown()

  function enter(prompt_bufnr)
    actions.close(prompt_bufnr)
    local selected = actions_state.get_selected_entry()
    local fullpath = selected.value
    if cmd == 'tcd' then
      local win_list = vim.api.nvim_tabpage_list_wins(0)
      local bufname = vim.fn.bufname(vim.fn.bufnr())
      if #win_list > 1 or bufname ~= '' then
        cmd = 'tabnew | tcd'
      end
    end
    vim.cmd(cmd .. ' ' .. fullpath)
  end

  local resultList = {}
  for path_i, dir in ipairs(dirs) do
    local i, t, popen = 0, {}, io.popen
    local path = popen('echo '..dir.path):read("*l")
    -- print(path)
    local maxdepth = 1
    if dir.maxdepth ~= nil then
      maxdepth = dir.maxdepth
    end
    local pfile = popen('find "'..path..'" -maxdepth '..maxdepth)
    for filename in pfile:lines() do
      i = i + 1
      filename = filename:gsub(path, '')
      -- print(filename)
      if filename == '' or (maxdepth > 1 and #vim.split(filename, '/') == 1 ) then
        -- print(filename, 'continue')
        goto continue
      end
      local category = ""
      if #dirs > 1 then
        category = dir.category
      end
      t[#t+1] = {
        fullpath = path .. filename,
        dirname = filename,
        ordinal = path .. filename,
        category = category
      }
      -- print(i, vim.inspect(t[i]))
      ::continue::
    end
    -- print(vim.inspect(t))
    resultList = vim.list_extend(resultList, t)
    pfile:close()
  end
  -- print(vim.inspect(resultList))

  local opts = {
    finder = finders.new_table({ results = resultList, entry_maker = function(item)
      local displayText = ""
      if (item.category ~= "") then
        displayText = '(' .. item.category .. ') ' .. item.dirname
      else
        displayText = item.dirname
      end
      return {
        value = item.fullpath,
        ordinal = item.ordinal,
        display = displayText
      }
    end }),
    sorter = sorters.get_generic_fuzzy_sorter({}),

    attach_mappings = function(prompt_bufnr, map)
      map("n", "<CR>", enter)
      map("i", "<CR>", enter)
      return true
    end,

  }

  local dir_picker = pickers.new(dropdown, opts)

  dir_picker:find()
end

function M.generateLorem(wordCount)
  if wordCount == nil then
    return ""
  end
  local lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum"
  local loremTbl = vim.split(lorem, ' ', { plain = true, trimempty = true })
  local result = ""
  for i = 0, wordCount - 1, 1 do
    local word = loremTbl[i % (#loremTbl) + 1]
    if i > wordCount - 5 then
      word = string.gsub(word, '[,.]', '')
    end
    result = result .. " " .. word
  end
  result = result .. "."
  return vim.trim(result)
end

function M.getCmdOutputLines(cmd)
  return M.getStdoutOf(cmd .. " 2>&1")
end

function M.getStdoutOf(cmd)
  local i, t, popen = 0, {}, io.popen
  local pfile = popen(cmd)
  local lines = {}
  for filename in pfile:lines() do
    i = i + 1
    lines[i] = filename
  end
  pfile:close()
  return lines
end

function M.CheckFileExists(filepath)
  local filepath = M.ExpandEnvs(filepath)
  local file, err = io.open(filepath, 'r')
  if file ~= nil then
    file:close()
  end
  if err ~= nil then
    return false
  end
  return true
end

function M.ExpandEnvs(string)
  return io.popen('echo '..string):read("*l")
end

-- The range of ts nodes start with 0 and the ending range is exclusive.
function M.VisualSelectionRange()
  local _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
  local _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
  if csrow < cerow or (csrow == cerow and cscol <= cecol) then
    return csrow - 1, cscol - 1, cerow - 1, cecol
  else
    return cerow - 1, cecol - 1, csrow - 1, cscol
  end
end

function M.GetVisual()
  local start_line, start_col, end_line, end_col = M.VisualSelectionRange()
  if start_col == 2147483647 then
    start_col = -1
  end
  if end_col == 2147483647 then
    end_col = -1
  end
  return start_line, start_col, end_line, end_col, vim.api.nvim_buf_get_text(0, start_line, start_col, end_line, end_col, {})
end

function M.contains(table, value)
  for idx, v in ipairs(table) do
    if v == value then
      return idx
    end
  end
  return nil
end


return M
