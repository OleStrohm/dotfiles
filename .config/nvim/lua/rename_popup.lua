OnRenameChange = function(text)
  print("New name:", text)
end

OnRenameDone = function(text)
  print("Final name:", text)
end

Popup = function()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1]
  local col = cursor[2]

  -- Makes an unlisted scratch buffer
  local bufnr = vim.api.nvim_create_buf(false, true)
  assert(bufnr, "Failed to create buffer")

  local variable = vim.api.nvim_get_current_line()

  -- Start off the buffer with current name
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, { variable })

  local win_opts = {
    relative = 'cursor',
    style = 'minimal',
    row = 0,
    col = 0,
    width = #variable,
    height = 1,
    noautocmd = false,
    zindex = 50,
  }
  local win_id = vim.api.nvim_open_win(bufnr, true, win_opts)

  vim.keymap.set({ "n", "i" }, "<cr>", function()
    OnRenameDone(vim.api.nvim_get_current_line())
    vim.api.nvim_win_close(win_id, true)
    vim.cmd [[ stopinsert ]]
  end, { silent = true, buffer = bufnr })

  vim.cmd(string.format([[
    autocmd TextChanged,TextChangedI <buffer=%s> lua OnRenameChange(vim.api.nvim_get_current_line())
  ]], bufnr, bufnr))

  print(vim.fn.expand("<cword>"))
end
