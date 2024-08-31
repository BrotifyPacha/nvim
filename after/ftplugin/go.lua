local helpers = require "user.helpers"
local caseswitcher = require "caseswitcher"

function MockInterfaceUnderCusor()
  local pkg_name = helpers.getStdoutOf("go list")
  if #pkg_name == 0 then
    print("no pkg found")
    return
  end

  local current_dir = vim.fn.expand("%:h")
  local word_under_cursor = vim.fn.expand("<cword>")
  local interface = pkg_name[1] .. "/" .. current_dir .. "." .. word_under_cursor

  local filename = current_dir .. "/" .. "mock_" .. caseswitcher.recombineWord("snake", word_under_cursor) .. "_test.go"

  local cmd = "minimock -i " .. interface .. " -o ".. filename

  vim.fn.system(cmd)

end

function AddErrorOrSecondReturnArgument()
  local wordUnderCursor = vim.fn.expand("<cword>")
  if wordUnderCursor == "error" then
	vim.cmd [[normal siW)a, F(l]]
	vim.cmd [[startinsert]]
  else
	vim.cmd [[normal siW)%i, error]]
  end
end
