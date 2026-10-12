local M = {}

---@alias bp.agent "claude" | "opencode"
---@class bp.agent.session
---@field agent bp.agent
---@field buf integer
---@field job integer

--- sessions per working directory
---@type table<string, bp.agent.session[]>
local sessions = {}

function M.cleanup()
  for wd, list in pairs(sessions) do

    local valid = {}

    for _, s in ipairs(list) do
      if vim.api.nvim_buf_is_valid(s.buf) then
        valid[#valid + 1] = s
      end
    end

    sessions[wd] = valid
  end
end

---@param buf integer
---@return bp.agent.session?
local function find_by_buf(buf)
  for _, list in pairs(sessions) do
    for _, s in ipairs(list) do
      if s.buf == buf then
        return s
      end
    end
  end
end

---@param agent bp.agent
function M.summon(agent)
  M.cleanup()

  local wd = vim.fn.getcwd(0)

  local list = sessions[wd] or {}
  local candidates = vim.tbl_filter(function(s) return s.agent == agent end, list)

  if #candidates == 0 then
    return M.open(agent)
  end

  local current = find_by_buf(vim.api.nvim_get_current_buf())
  if not current or current.agent ~= agent then
    return M.show(candidates[1])
  end

  for i, s in ipairs(candidates) do
    if s == current then
      vim.notify(string.format("Showing %d/%d", i, #candidates))
      return M.show(candidates[i % #candidates + 1])
    end
  end
end

---@param agent bp.agent
function M.open(agent)
  M.cleanup()

  local wd = vim.fn.getcwd(0)

  local buf = vim.api.nvim_create_buf(true, false)
  local job
  vim.api.nvim_buf_call(buf, function()
    job = vim.fn.jobstart(agent, { term = true }) -- nvim < 0.11: vim.fn.termopen(agent)
  end)

  local s = {
    agent = agent,
    buf = buf,
    job = job,
  }

  sessions[wd] = sessions[wd] or {}
  table.insert(sessions[wd], s)

  M.show(s)

end

---@param s bp.agent.session
function M.show(s)

  local win = vim.fn.bufwinid(s.buf)

  if win == -1 then
    if find_by_buf(vim.api.nvim_get_current_buf()) then
      win = vim.api.nvim_get_current_win()
    else
      vim.cmd("botright vsplit")
      win = vim.api.nvim_get_current_win()
      vim.api.nvim_win_set_width(win, math.floor(vim.o.columns * 0.4))
    end
    vim.api.nvim_win_set_buf(win, s.buf)
  else
    vim.api.nvim_set_current_win(win)
  end

  vim.wo[win].number = false
  vim.wo[win].signcolumn = "yes:1"

  vim.cmd("startinsert")
end

--- pick the agent session to send text to: a visible one in the current
--- working directory if any, otherwise the most recently opened one
---@return bp.agent.session?
local function pick_target()
  M.cleanup()

  local list = sessions[vim.fn.getcwd(0)] or {}

  for i = #list, 1, -1 do
    if vim.fn.bufwinid(list[i].buf) ~= -1 then
      return list[i]
    end
  end

  return list[#list]
end

--- send a reference as `@path#L<start>-<end>` to an agent terminal as a
--- bracketed paste, without submitting it
local function send_link_range(first, last)
  local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.")
  if path == "" then
    return vim.notify("Buffer has no file", vim.log.levels.WARN)
  end

  local s = pick_target()
  if not s then
    return vim.notify("No agent session", vim.log.levels.WARN)
  end

  local range = first == last and first or (first .. "-" .. last)
  vim.fn.chansend(s.job, "\27[200~@" .. path .. "#L" .. range .. " \27[201~")

  if vim.fn.bufwinid(s.buf) == -1 then
    vim.notify("Sent to hidden " .. s.agent .. " session")
  end
end

--- operatorfunc: send a link to the lines covered by the motion
function M.send_link()
  send_link_range(vim.fn.line("'["), vim.fn.line("']"))
end

return M
