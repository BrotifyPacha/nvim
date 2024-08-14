
vim.g.db_ui_execute_on_save = 0

vim.g.db_ui_disable_mappings_dbui = 1
vim.g.db_ui_disable_mappings_sql = 1


vim.api.nvim_create_autocmd('User', {
  pattern = 'DBUIOpened',
  callback = function (event)

    vim.api.nvim_buf_set_keymap(0,  "n", "<CR>", "<Plug>(DBUI_SelectLine)", { noremap=1 })
    vim.api.nvim_buf_set_keymap(0,  "n", "o",    "<Plug>(DBUI_SelectLine)", { noremap=1 })

    vim.api.nvim_buf_set_keymap(0,  "n", "A",    "<Plug>(DBUI_AddConnection)", { noremap=1 })
    vim.api.nvim_buf_set_keymap(0,  "n", "d",    "<Plug>(DBUI_DeleteLine)", { noremap=1 })
    vim.api.nvim_buf_set_keymap(0,  "n", "r",    "<Plug>(DBUI_RenameLine)", { noremap=1 })

    vim.api.nvim_buf_set_keymap(0,  "n", "R",    "<Plug>(DBUI_Redraw)", { noremap=1 })

    vim.api.nvim_buf_set_keymap(0,  "n", "K",    "<Plug>(DBUI_ToggleDetails)", { noremap=1 })

    vim.api.nvim_buf_set_keymap(0,  "n", "s",    "<Plug>(DBUI_SelectLineVsplit)", { noremap=1 })

    vim.api.nvim_buf_set_keymap(0,  "n", "K",    "<Plug>(DBUI_GotoFirstSibling)", { noremap=1 })
    vim.api.nvim_buf_set_keymap(0,  "n", "J",    "<Plug>(DBUI_GotoLastSibling)", { noremap=1 })
    vim.api.nvim_buf_set_keymap(0,  "n", "p",    "<Plug>(DBUI_GotoParentNode)", { noremap=1 })
  end,
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function (event)
    if vim.o.ft ~= "sql" then
      return
    end

    vim.api.nvim_buf_set_keymap(0,  "n", "<cr>",    "<Plug>(DBUI_ExecuteQuery)", { noremap=1 })
    vim.api.nvim_buf_set_keymap(0,  "v", "<cr>",    "<Plug>(DBUI_ExecuteQuery)", { noremap=1 })

  end,
})
