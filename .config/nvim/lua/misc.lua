vim.g.floaterm_autoclose = 1
function nnoremap(shortcut, command)
    vim.api.nvim_set_keymap("n", shortcut, command, { noremap = true, silent = true })
end
function tnoremap(shortcut, command)
    vim.api.nvim_set_keymap("t", shortcut, command, { noremap = true, silent = true })
end
nnoremap("<leader>w", ":write<cr>")
nnoremap("Q", "@q")
nnoremap("<leader>vp", ":Telescope find_files search_dirs=$HOME/.config/nvim/<cr>")

nnoremap("<leader>c", ":nohlsearch<cr>")

-- terminal
nnoremap("<leader>T", ":split<cr>:terminal<cr>i")

-- Movement
tnoremap("<M-h>", "<c-\\><c-n><c-w>h")
tnoremap("<M-j>", "<c-\\><c-n><c-w>j")
tnoremap("<M-k>", "<c-\\><c-n><c-w>k")
tnoremap("<M-l>", "<c-\\><c-n><c-w>l")
nnoremap("<M-h>", "<c-w>h")
nnoremap("<M-j>", "<c-w>j")
nnoremap("<M-k>", "<c-w>k")
nnoremap("<M-l>", "<c-w>l")
