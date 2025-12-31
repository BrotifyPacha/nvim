
vim.diagnostic.config({
  virtual_text = false,
  signs = false, --disable signs here to customly display them later
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "single",
    source = "if_many",
    header = "Diagnostics:",
  }
})

-- Create a namespace. This won't be used to add any diagnostics,
-- only to display them.
local ns = vim.api.nvim_create_namespace("my_namespace")

-- Create a reference to the original function
local show = vim.diagnostic.show

local function contains_diagnostic_with_severity(diagnostics, diagnostic)
  for _, present_diag in pairs(diagnostics) do
    if present_diag.severity == diagnostic.severity then
      return true
    end
  end
  return false
end

local function set_signs(bufnr)
  -- Get all diagnostics from the current buffer
  local diagnostics = vim.diagnostic.get(bufnr)
  -- Find the "worst" diagnostic per line
  local one_sign_per_severity_per_line = {}
  for _, d in pairs(diagnostics) do
    if one_sign_per_severity_per_line[d.lnum] then
      local present_diags = one_sign_per_severity_per_line[d.lnum]
      if contains_diagnostic_with_severity(present_diags, d) ~= true then
        one_sign_per_severity_per_line[d.lnum] = table.insert(present_diags, d)
      end
    else
      one_sign_per_severity_per_line[d.lnum] = {d}
    end
  end
  local filtered_diagnostics = {}
  for _, v in pairs(one_sign_per_severity_per_line) do
    for _, j in pairs(v) do
      table.insert(filtered_diagnostics, j)
    end
  end
  -- Show the filtered diagnostics using the custom namespace. Use the
  -- reference to the original function to avoid a loop.
  show(ns, bufnr, filtered_diagnostics, {
    virtual_text = false,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "",
        [vim.diagnostic.severity.WARN] = "",
        [vim.diagnostic.severity.HINT] = "",
        [vim.diagnostic.severity.INFO] = "",
      },
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "single",
      source = "if_many",
      header = "",
      prefix = "",
    }
  })
end

function vim.diagnostic.show(namespace, bufnr, ...)
  show(namespace, bufnr, ...)
  set_signs(bufnr)
end
