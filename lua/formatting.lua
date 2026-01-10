local M = {}

-- test( a, "b1, b2 + hehe", c) haahha
--
-- nnoremap <leader>rt :lua require("user.helpers").reload("formatting").toggle_multiline_args()<cr>

function M.toggle_multiline_args(opts)
  if opts == nil then
    opts = {}
  end

  local initial_pos = vim.api.nvim_win_get_cursor(0)

  local open_brace = vim.fn.searchpos("(", "c")
  local open_brace_line = open_brace[1]
  local open_brace_col = open_brace[2]

  local close_brace = vim.fn.searchpairpos("(", "*", ")", "nz")
  local close_brace_line = close_brace[1]
  local close_brace_col = close_brace[2]

  local lines = vim.api.nvim_buf_get_lines(0, open_brace_line-1, close_brace_line, false)
  local new_lines = {}

  if #lines == 0 then
    return
  end

  if #lines == 1 then
    -- to multiline
    local line = lines[1]

    local pre_split = line:sub(1, open_brace_col)
    local part_to_split = line:sub(open_brace_col+1, close_brace_col-1)
    local post_split = line:sub(close_brace_col)

    local split_parts = {}
    local tmp_line = ""
    local escape_stack = 0

    -- test("d" + "e", "haha") haahha
    local i = 1
    while i <= #part_to_split do

      local c = part_to_split:sub(i, i)

      if vim.list_contains({ "(", "{", '[' }, c) then
        escape_stack = escape_stack + 1
      end

      if vim.list_contains({ ")", "}", ']' }, c) then
        escape_stack = escape_stack - 1
      end

      -- custom logic for strings: consume them as-is until closing
      -- string char found
      if vim.list_contains({ '"', "'", "`" }, c) then
        local string_symbol = c
        local string_start = i
        -- local escape_symbol = strings_to_escapes[string_symbol]
        for j = i, #part_to_split do
          local jc = part_to_split:sub(j, j)
          local escaped = ("\\" .. string_symbol) == part_to_split:sub(j-1, j)
          tmp_line = tmp_line .. jc
          if (jc == string_symbol and j ~= string_start and not escaped) or (jc == #part_to_split) then
            i = j
            goto continue
          end
        end
      end

      tmp_line = tmp_line .. c

      ::continue::

      if (c == "," and escape_stack == 0) or (i == #part_to_split) then
        table.insert(split_parts, tmp_line)
        tmp_line = ""
      end

      i = i + 1

      -- vim.print({ #part_to_split, i, c, tmp_line, split_parts })

    end

    for i, s in ipairs(split_parts) do
      split_parts[i] = vim.trim(s)

      if i == #split_parts and opts.last_item_coma then
        split_parts[i] = vim.trim(s) .. ","
      end
    end

    table.insert(new_lines, pre_split)
    vim.list_extend(new_lines, split_parts)
    table.insert(new_lines, post_split)

    -- vim.print({ initial_pos, open_brace, close_brace, part_to_split })

  else
    --              \/ ----------- split from here
    -- function_call( arg1,
    -- arg2,
    -- arg3
    -- arg4 ) + maybe stuff here
    --     /\ -------------------- to about here

    local pre_open_brace = lines[1]:sub(1, open_brace_col)
    local possible_arg_1 = lines[1]:sub(open_brace_col+1)
    local possible_last_arg = lines[#lines]:sub(1, close_brace_col-1)
    local post_closing_brace = lines[#lines]:sub(close_brace_col)

    lines[1] = possible_arg_1
    lines[#lines] = possible_last_arg

    local args = {}
    for _, arg in ipairs(lines) do

      arg = vim.trim(arg)

      if vim.endswith(arg, ",") then
        arg = arg:sub(1, #arg-1)
      end

      if arg == "" then
        goto continue
      end

      args[#args+1] = arg

      ::continue::
    end

    new_lines = { pre_open_brace .. table.concat(args, ", ") .. post_closing_brace }

  end

  vim.api.nvim_buf_set_lines(0, open_brace_line-1, close_brace_line, false, new_lines)

  local cmd = "normal! " .. open_brace_line .. "G=" .. close_brace_line + #new_lines-1 .. "G"
  -- vim.print(cmd)
  vim.cmd (cmd)

  vim.api.nvim_win_set_cursor(0, initial_pos)

end

return M
