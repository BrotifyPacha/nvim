local helpers = require('user.helpers')
local dap = require('dap')

-- Php
dap.adapters.php = {
  type = 'executable',
  command = 'node',
  args = { vim.fn.stdpath('config') .. '/debuggers/php/vscode-php-debug/out/phpDebug.js' }
}
dap.configurations.php = {
  {
    type = 'php',
    request = 'launch',
    name = 'Listen for Xdebug',
    -- stopOnEntry = true,
    pathMappings = function ()
      return {
        ['/var/www'] = vim.fn.getcwd() .. '/app'
      }
    end,
    port = 9000
  }
}

-- Go
dap.adapters.go = function(callback, config)
  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)
  local handle
  local pid_or_err
  local port = 62001
  local opts = {
    stdio = {nil, stdout, stderr},
    args = {"dap", "-l", "127.0.0.1:" .. port},
    detached = true
  }
  handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
    stdout:close()
    stderr:close()
    handle:close()
    if code ~= 0 then
      print('dlv exited with code', code)
    end
  end)
  assert(handle, 'Error running dlv: ' .. tostring(pid_or_err))

  local read_output = function(stream, pipe)
    return function(err, chunk)
      assert(not err, err)
      if not chunk then
        return
      end
      vim.schedule(function()
        chunk = vim.fn.substitute(chunk, "\n$", "", "")
        for _, line in ipairs(vim.split(chunk, "\n")) do
          require('dap.repl').append('[' .. stream .. '] ' .. line)
        end
      end)
    end
  end

  stdout:read_start(read_output('stdout', stdout))
  stderr:read_start(read_output('stderr', stderr))

  -- Wait for delve to start
  vim.defer_fn(
    function()
      callback({type = "server", host = "127.0.0.1", port = port})
    end,
    100
  )
end

-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
function runLast()
  vim.t.customDapRunLast = true
  dap.run_last()
end

function runNewOrRunLast(default)
  return function ()
    if vim.t.customDapRunLast ~= nil then
      vim.t.customDapRunLast = nil
      return vim.t.customDapRunLastFile
    end
    print('runNewOrRunLast arg = ', default)
    local expanded = ''
    if default == '${file}' then
      expanded = vim.fn.expand('%:p')
    elseif default == 'go_entry_point' then
      expanded = helpers.PickGoMainFile() or ''
    end
    vim.t.customDapRunLastFile = expanded
    return expanded
  end
end

function runSpecificTest()
  return function ()
    if vim.t.customDapRunLast ~= nil then
      vim.t.customDapRunLast = nil
      return { '-test.run', vim.t.customDapRunLastFunc }
    end
    local func = vim.fn.expand('<cword>')

    vim.ui.input(
      {
        prompt = 'Enter name of function to test: ',
        default = func,
      },
      function (input)
        func = input
        vim.t.customDapRunLastFunc = func
      end
    )
    return { '-test.run', func }
  end
end

dap.configurations.go = {
  {
    type = "go",
    name = "Debug go entrypoint",
    request = "launch",
    program = runNewOrRunLast("go_entry_point"),
    buildFlags = { "-buildvcs=false" },
    args = {},
  },
  {
    type = "go",
    name = "Debug pre-compiled binary",
    request = "launch",
    mode = "exec",
    program = "./_debug_bin",
  },
  {
    type = "go",
    name = "Debug test (File)",
    request = "launch",
    mode = "test",
    program = runNewOrRunLast("${file}"),
    buildFlags = { "-tags", "integration" },
  },
  {
    type = "go",
    name = "Debug test (Func)",
    request = "launch",
    mode = "test",
    program = "./${relativeFileDirname}",
    args = runSpecificTest(),
    buildFlags = { "-tags", "integration" },
  },
  -- works with go.mod packages and sub packages
  {
    type = "go",
    name = "Debug test (Project)",
    request = "launch",
    mode = "test",
    program = "./${relativeFileDirname}",
    buildFlags = { "-tags", "integration" },
  },
  {
    type = "go",
    name = "Debug benchmark (Project)",
    request = "launch",
    mode = "test",
    program = "./${relativeFileDirname}",
    args = { "-test.bench", "." },
    buildFlags = { "-tags", "integration" },
  },
  {
    type = "go",
    name = "Debug delve go",
    request = "launch",
    program = runNewOrRunLast("go_entry_point"),
    args = {},
    dlvCwd = "/Users/pavgusev/workspace/playground/go-delve-playground",
    cwd = "/Users/pavgusev/workspace/playground/go-delve-playground",
  },
}

-- Python
require('dap-python').setup('/usr/bin/python')
dap.configurations.python = {
  {
    type = 'python',
    request = 'launch',
    name = 'Debug file',
    program = runNewOrRunLast('${file}'),
  }
}
