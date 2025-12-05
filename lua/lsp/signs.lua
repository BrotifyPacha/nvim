
local signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
}

for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

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
    source = "always",
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
      active = signs
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "single",
      source = "always",
      header = "",
      prefix = "",
    }
  })
end

function vim.diagnostic.show(namespace, bufnr, ...)
  show(namespace, bufnr, ...)
  set_signs(bufnr)
end

local open_float = vim.diagnostic.open_float

function vim.diagnostic.open_float(...)

  local diagnostics = vim.diagnostic.get(0)

  local withoutTags = {}

  local namespace = 0

  for _, d in ipairs(diagnostics) do

    namespace = d.namespace

    if d._tags == nil then
      withoutTags[#withoutTags+1] = d
    end
  end

  vim.diagnostic.set(namespace, 0, withoutTags)

  open_float(...)

end
