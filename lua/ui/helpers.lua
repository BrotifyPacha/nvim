local M = {}

M.link = function (subject, link_to)
  vim.api.nvim_set_hl(0, subject, { link = link_to })
end

M.get_hl = function (name)
  return vim.api.nvim_get_hl(0, { name = name , link = false})
end

M.create_hl = function (name, opts)
  opts.force = true
  vim.api.nvim_set_hl(0, name, opts)
end

M.reverse = function (name)
  local hl = M.get_hl(name)
  hl.fg, hl.bg = hl.bg, hl.fg
  return hl
end

M.extend = function (name, opts)
  local hl = M.get_hl(name)
  return vim.tbl_extend("force", hl, opts)
end

return M
