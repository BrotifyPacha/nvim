local h = require("null-ls.helpers")
local methods = require("null-ls.methods")

local DIAGNOSTICS = methods.internal.DIAGNOSTICS

local my_protobuf_lint = h.make_builtin({
  name = "buf_lint",
  meta = {
    url = "https://github.com/bufbuild/buf",
    description = "A new way of working with Protocol Buffers.",
  },
  method = DIAGNOSTICS,
  filetypes = { "proto" },
  generator_opts = {
    command = "buf",
    args = { "lint", "$FILENAME#include_package_files=true" },
    from_stderr = true,
    to_stdin = true,
    format = "line",
    check_exit_code = function(code)
      print(DIAGNOSTICS)
      return code <= 1
    end,
    on_output = h.diagnostics.from_patterns({
      {
        pattern = [[(.*):(%d+):(%d+):(.*)]],
        groups = { "filename", "row", "col", "message" },
      },
      {
        pattern = [[(.*)]],
        groups = { "message" },
      }
    }),
  },
  factory = h.generator_factory,
})

local null_ls = require 'null-ls'

local sources = {
  null_ls.builtins.diagnostics.phpcs.with({
    extra_args = { '--standard=psr12' },
    diagnostics_format = "#{m}",
    diagnostics_postprocess = function (diagnostic)
      diagnostic.severity = vim.diagnostic.severity.WARN
    end
  }),
  my_protobuf_lint,
}

require 'null-ls'.setup({ sources = sources })
