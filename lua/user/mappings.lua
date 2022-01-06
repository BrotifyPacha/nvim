
vim.api.nvim_set_keymap('n', '<leader><leader>', ':call search("<++>", "cw")<cr>c4l', { expr = false, noremap = true })

-- Plugin mappings
-- -- Easy align
vim.api.nvim_set_keymap('n', 'ga', '<Plug>(EasyAlign)', { expr = false, noremap = false })
vim.api.nvim_set_keymap('x', 'ga', '<Plug>(EasyAlign)', { expr = false, noremap = false })
-- -- Exchange
vim.api.nvim_set_keymap('n', 'cx', '<Plug>(Exchange)', { expr = false, noremap = false })
vim.api.nvim_set_keymap('n', 'cxx', '<Plug>(ExchangeLine)', { expr = false, noremap = false })
-- -- Surround
vim.api.nvim_set_keymap('n', 's', '<Plug>Ysurround', { expr = false, noremap = false })
vim.api.nvim_set_keymap('n', 'ss', '<Plug>Yssurround', { expr = false, noremap = false })
vim.api.nvim_set_keymap('v', 's', '<Plug>VSurround', { expr = false, noremap = false })
vim.api.nvim_set_keymap('n', 'S', 's', { expr = false, noremap = false })


-- Text objects
vim.api.nvim_set_keymap('o', 'id', ":lua require 'mytextobj'.documentTextObj()<cr>", { expr = false, noremap = true })
vim.api.nvim_set_keymap('x', 'id', ":lua require 'mytextobj'.documentTextObj()<cr>", { expr = false, noremap = true })
vim.api.nvim_set_keymap('o', 'ie', ":lua require 'mytextobj'.expressionTextObj()<cr>", { expr = false, noremap = true })
vim.api.nvim_set_keymap('x', 'ie', ":lua require 'mytextobj'.expressionTextObj()<cr>", { expr = false, noremap = true })
vim.api.nvim_set_keymap('o', 'ii', ":lua require 'mytextobj'.indentTextObj()<cr>", { expr = false, noremap = true })
vim.api.nvim_set_keymap('x', 'ii', ":lua require 'mytextobj'.indentTextObj()<cr>", { expr = false, noremap = true })


-- Surround extension
vim.api.nvim_set_keymap('n', 'dsf', ':call formatting#delete_surrounding_func()<cr>', { expr = false, noremap = true })
vim.api.nvim_set_keymap('n', 'csf', ':call formatting#change_surrounding_func("")<cr>', { expr = false, noremap = true })

-- Unimpared extension
vim.api.nvim_set_keymap('n', '[t', ':tabprevious<cr>', { expr = false, noremap = true })
vim.api.nvim_set_keymap('n', ']t', ':tabnext<cr>', { expr = false, noremap = true })
vim.api.nvim_set_keymap('n', '[g', ':lua require"gitsigns".prev_hunk()<cr>zz', { expr = false, noremap = true })
vim.api.nvim_set_keymap('n', ']g', ':lua require"gitsigns".next_hunk()<cr>zz', { expr = false, noremap = true })
vim.api.nvim_set_keymap('n', 'g]p', 'ddmm}P`m:call repeat#set("m]p")<cr>', { expr = false, noremap = true })
vim.api.nvim_set_keymap('n', 'g[p', 'ddkmm{p`m:call repeat#set("m[p")<cr>', { expr = false, noremap = true })


-- Misc key maps
vim.api.nvim_set_keymap('n', 'n', 'nzz', { expr = false, noremap = true })
vim.api.nvim_set_keymap('n', 'N', 'Nzz', { expr = false, noremap = true })
vim.api.nvim_set_keymap('n', 'gF', ':e <cfile><cr>', { expr = false, noremap = true })
vim.api.nvim_set_keymap('n', 'cy', '"*y', { expr = false, noremap = true })
vim.api.nvim_set_keymap('n', 'cp', ':set paste | normal! "*p:set nopaste<cr>', { expr = false, noremap = true })

vim.api.nvim_set_keymap('n', 'cw', 'ciw', { expr = false, noremap = true })
vim.api.nvim_set_keymap('n', 'vv', '^v$h', { expr = false, noremap = true })
vim.api.nvim_set_keymap('n', 'Y', 'yg_', { expr = false, noremap = true })

vim.api.nvim_set_keymap('n', 'Q', '@@', { expr = false, noremap = true })
vim.api.nvim_set_keymap('n', 'q:', '<nop>', { expr = false, noremap = true })
vim.api.nvim_set_keymap('n', 'q/', '<nop>', { expr = false, noremap = true })
vim.api.nvim_set_keymap('n', 'q?', '<nop>', { expr = false, noremap = true })


-- F key maps
vim.api.nvim_set_keymap('n', '<F5>', ':nohl<cr>', { expr = false, noremap = true })
vim.api.nvim_set_keymap('n', '<F6>', ':set list!<cr>', { expr = false, noremap = true })
vim.api.nvim_set_keymap('n', '<F7>', ':set wrap!<cr>', { expr = false, noremap = true })
vim.api.nvim_set_keymap('n', '<F8>', ':ColorizerToggle<cr>', { expr = false, noremap = true })

-- Terminal mode key maps
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { expr = false, noremap = true })

-- Insert mode key maps
vim.api.nvim_set_keymap('i', '<C-f>', '<C-x><C-f>', { expr = false, noremap = true })
vim.api.nvim_set_keymap('i', '<C-l>', '<C-x><C-l>', { expr = false, noremap = true })

-- Smart tab
local function t(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end
function _G.smart_tab()
    return vim.fn.pumvisible() == 1 and t'<C-n>' or t'<Tab>'
end
function _G.smart_tab_backward()
    return vim.fn.pumvisible() == 1 and t'<C-p>' or t'<S-Tab>'
end

vim.api.nvim_set_keymap('i', '<Tab>', 'v:lua.smart_tab()', { expr = true, noremap = true })
vim.api.nvim_set_keymap('i', '<S-Tab>', 'v:lua.smart_tab_backward()', { expr = true, noremap = true })


