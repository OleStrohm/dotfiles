-- Settings {{{
vim.o.compatible = false
vim.o.showmode = false
vim.o.wrap = true
vim.o.modelines = 0
vim.o.scrolloff = 5
vim.o.ttyfast = true
vim.o.laststatus = 2
vim.o.autoindent = true
vim.o.showmode = true
vim.o.showcmd = true
vim.o.number = true
vim.o.cursorline = true
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.ts = 4
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.signcolumn = "no"
vim.o.completeopt="menu,menuone,noinsert,noselect"
vim.o.shortmess=vim.o.shortmess .. "c"
vim.o.exrc = true
vim.o.secure = true
vim.o.updatetime = 300
vim.g.loaded_python_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
vim.cmd([[
syntax enable
filetype plugin indent on
]])
-- }}}

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.api.nvim_set_keymap('', "<space>", "<nop>", { noremap = true, silent = true })
function nnoremap(shortcut, command)
    vim.api.nvim_set_keymap("n", shortcut, command, { noremap = true, silent = true })
end
nnoremap("<leader>ev", ":tabedit $MYVIMRC<cr>")
nnoremap("<leader>sv", ":source $MYVIMRC<cr>")

