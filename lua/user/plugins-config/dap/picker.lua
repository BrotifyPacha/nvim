-- Floating picker used by <leader>da to build up a dap config's args/env
-- before running it. <Tab>/<S-Tab> switches between the Args/Env tabs, `t`
-- toggles the item under the cursor, `a` opens a blank line in place and
-- `e` edits the line under the cursor - type the value and press <CR> in
-- insert mode to commit it (new items come toggled on), <Esc> cancels.
-- <CR> in normal mode runs with whatever's toggled on across both tabs.

local profiles = require('user.plugins-config.dap.profiles')
local history = require('user.plugins-config.dap.history')

local M = {}

local width, height = 60, 12

local function dedup(list)
  local seen, out = {}, {}
  for _, v in ipairs(list) do
    if v ~= "" and not seen[v] then
      seen[v] = true
      table.insert(out, v)
    end
  end
  return out
end

local function env_to_strings(env)
  local out = {}
  for k, v in pairs(env or {}) do
    table.insert(out, k .. "=" .. tostring(v))
  end
  return out
end

local function to_set(list)
  local set = {}
  for _, v in ipairs(list) do
    set[v] = true
  end
  return set
end

-- Turns a candidate string list into { text, enabled } items, deduped,
-- toggled on by default when they're in `hist_set`.
local function to_items(list, hist_set)
  local items = {}
  for _, v in ipairs(dedup(list)) do
    table.insert(items, { text = v, enabled = hist_set[v] == true })
  end
  return items
end

-- Gathers args/env candidate items for `config` from dap-profiles.json /
-- launch.json, history of previously used values, and the config's own
-- defaults. Values found in history come toggled on by default.
local function collect_candidates(config)
  local args = { unpack(config.args or {}) }
  local env = env_to_strings(config.env)

  local hist_args, hist_env = history.get(config.name)
  vim.list_extend(args, hist_args)
  vim.list_extend(env, hist_env)

  for _, profile in ipairs(profiles.get_profiles(vim.bo.filetype, config.name)) do
    vim.list_extend(args, profile.args or {})
    vim.list_extend(env, env_to_strings(profile.env))
  end

  return to_items(args, to_set(hist_args)), to_items(env, to_set(hist_env))
end

-- config: a dap configuration table (as found in dap.configurations[ft]).
-- on_confirm: called with a copy of `config` that has `args`/`env` filled in.
function M.pick_args_and_env(config, on_confirm)
  local args_items, env_items = collect_candidates(config)
  local tabs = { { title = "Arguments", items = args_items }, { title = "Environment", items = env_items } }

  local active = 1
  local ns = vim.api.nvim_create_namespace("dap_picker")
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    row = math.floor(vim.o.lines / 2 - height / 2),
    col = math.floor(vim.o.columns / 2 - width / 2),
    width = width,
    height = height,
    border = "single",
    title = config.name,
    title_pos = "center",
    -- footer = " <Tab> switch  t toggle  a add  e edit  <CR> run ",
    -- footer_pos = "center",
  })
  vim.api.nvim_set_option_value("number", false, { win = win })
  vim.api.nvim_set_option_value("signcolumn", "yes:2", { win = win })
  vim.api.nvim_set_option_value("winhighlight", "NormalFloat:Normal", { win = win })

  local function format_lines(page)
    local lines = {}
    for _, item in ipairs(page.items) do
      table.insert(lines, item.text)
    end
    return lines
  end

  -- Shows enabled/disabled as a sign in the signcolumn instead of an
  -- inline "[x]"/"[ ]" prefix.
  local function place_signs(page)
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    for i, item in ipairs(page.items) do
      vim.api.nvim_buf_set_extmark(buf, ns, i - 1, 0, {
        sign_text = item.enabled and " 󰡖" or " 󰄱",
        sign_hl_group = item.enabled and "DiagnosticOk" or "Comment",
      })
    end
  end

  -- Builds "[Arguments] -  Environments", bracketing whichever tab is
  -- active. Inactive tabs get space padding the same width as the
  -- brackets, so a tab's layout doesn't shift when it (de)activates.
  local function tab_bar_title()
    local parts = {}
    for i, tab in ipairs(tabs) do
      local open, close = " ", " "
      if i == active then
        open, close = "[", "]"
      end
      table.insert(parts, open .. tab.title .. close)
    end
    return " " .. table.concat(parts, " ─ ") .. " "
  end

  local function render()
    local page = tabs[active]
    vim.api.nvim_win_set_config(win, { title = tab_bar_title(), title_pos = "center" })

    local lines = format_lines(page)
    vim.api.nvim_set_option_value("modifiable", true, { buf = buf })
    if #lines == 0 then
      vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, { " (no candidates, press a to add one)" })
    else
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      place_signs(page)
    end
    vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
  end

  local function close()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end

  local function toggle_current()
    local item = tabs[active].items[vim.api.nvim_win_get_cursor(win)[1]]
    if item then
      item.enabled = not item.enabled
      render()
    end
  end

  local function switch(step)
    active = (active + step - 1) % #tabs + 1
    vim.api.nvim_win_set_cursor(win, { 1, 0 })
    render()
  end

  -- Which line is being typed into right now: an existing item's index
  -- (edit) or one past the last item (add). commit_edit()/cancel_edit()
  -- (bound to insert-mode <CR>/<Esc>) read it to know what to update.
  local edit_index = nil

  -- Appends a blank line to the current tab and drops into insert mode on
  -- it, ready to become a new item.
  local function start_add()
    local page = tabs[active]
    local lines = format_lines(page)
    table.insert(lines, "")
    edit_index = #lines
    vim.api.nvim_set_option_value("modifiable", true, { buf = buf })
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    place_signs(page)
    vim.api.nvim_win_set_cursor(win, { edit_index, 0 })
    vim.cmd("startinsert!")
  end

  -- Drops into insert mode on the line under the cursor, editing that
  -- item's text in place.
  local function start_edit()
    local line = vim.api.nvim_win_get_cursor(win)[1]
    if not tabs[active].items[line] then
      return
    end
    edit_index = line
    vim.api.nvim_set_option_value("modifiable", true, { buf = buf })
    vim.api.nvim_win_set_cursor(win, { line, 0 })
    vim.cmd("startinsert!")
  end

  local function commit_edit()
    local value = vim.api.nvim_get_current_line():gsub("^%s*", ""):gsub("%s+$", "")
    vim.cmd("stopinsert")

    local items = tabs[active].items
    local item = items[edit_index]
    if item then
      if value ~= "" then
        item.text = value
      end
    elseif value ~= "" then
      table.insert(items, { text = value, enabled = true })
    end

    edit_index = nil
    render()
  end

  local function cancel_edit()
    vim.cmd("stopinsert")
    edit_index = nil
    render()
  end

  local function run()
    local args, env = {}, {}
    for _, item in ipairs(tabs[1].items) do
      if item.enabled then
        table.insert(args, item.text)
      end
    end
    for _, item in ipairs(tabs[2].items) do
      if item.enabled then
        table.insert(env, item.text)
      end
    end

    close()
    history.remember(config.name, args, env)

    local env_table = {}
    for _, pair in ipairs(env) do
      local key, value = pair:match("^([^=]+)=(.*)$")
      if key then
        env_table[key] = value
      end
    end

    local final_config = vim.deepcopy(config)
    final_config.args = args
    final_config.env = env_table
    on_confirm(final_config)
  end

  local opts = { buffer = buf, nowait = true }
  vim.keymap.set("n", "<Tab>", function() switch(1) end, opts)
  vim.keymap.set("n", "<S-Tab>", function() switch(-1) end, opts)
  vim.keymap.set("n", "t", toggle_current, opts)
  vim.keymap.set("n", "a", start_add, opts)
  vim.keymap.set("n", "o", start_add, opts)
  vim.keymap.set("n", "i", start_edit, opts)
  vim.keymap.set("n", "e", start_edit, opts)
  vim.keymap.set("n", "c", start_edit, opts)
  vim.keymap.set("n", "<CR>", run, opts)
  vim.keymap.set("n", "q", close, opts)
  vim.keymap.set("n", "<Esc>", close, opts)
  vim.keymap.set("i", "<CR>", commit_edit, opts)
  vim.keymap.set("i", "<Esc>", cancel_edit, opts)

  render()
end

return M
