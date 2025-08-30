local M = {}


local __go_list_dependency_dirs = function ()
  local handle = io.popen('go list -f "{{ .Dir }}" -m all 2>/dev/null')
  if not handle then return end

  local result = handle:read('*a')

  handle:close()

  if not result or result == '' then return end

  local dirs = {}
  local seen = {}
  for dir in result:gmatch('[^\r\n]+') do
    if not seen[dir] then
      table.insert(dirs, dir)
      seen[dir] = true
    end
  end

  return dirs
end

M.go_dependency_live_grep = function ()

  local dependency_dirs = __go_list_dependency_dirs()

  require('telescope.builtin').live_grep({
    prompt_title = 'Go dependency live-grep',
    cwd = nil, -- This will be set per entry
    search_dirs = dependency_dirs,
    entry_maker = function (entry)
      local modules_dir = vim.env.HOME .. "/go/pkg/mod/"

      local dependency, version, file = string.match(entry:gsub(modules_dir, ""), "(.*)@([^/]*)(.+)")
      -- vim.print(entry)
      return {
        value = entry,
        display = dependency .. " " .. version .. " " .. file,
        ordinal = entry,
      }
    end
  })

end

return M
