-- Settings {{{
vim.o.compatible = false
vim.o.showmode = false
vim.o.wrap = true
vim.o.modelines = 0
vim.o.scrolloff = 5
vim.o.ttyfast = true
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
vim.o.mouse = "nv"
vim.g.loaded_python_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
vim.o.foldmethod="marker"
vim.cmd([[
  syntax enable
  filetype plugin indent on
]])
-- }}}

--- Folding {{{
vim.opt.foldopen:remove { "search" }

vim.keymap.set("n", "/", "zn/", { desc = "Search and Pause Folds" })
vim.on_key(function(char)
  local key = vim.fn.keytrans(char)
  local searchKeys = { "n", "N", "*", "#", "/", "?" }
  local searchConfirmed = (key == "<CR>" and vim.fn.getcmdtype():find("[/?]") ~= nil)
  if not (searchConfirmed or vim.fn.mode() == "n") then return end

  local searchKeyUsed = searchConfirmed or (vim.tbl_contains(searchKeys, key))
  local pauseFold = vim.opt.foldenable:get() and searchKeyUsed
  local unpauseFold = not (vim.opt.foldenable:get()) and not searchKeyUsed
  if pauseFold then
    vim.opt.foldenable = false
  elseif unpauseFold then
    vim.opt.foldenable = true
    vim.cmd.normal("zv")
  end
end, vim.api.nvim_create_namespace("auto_pause_folds"))

vim.keymap.set("n", "h", function()
  local onIndentOrFirstNonBlank = vim.fn.virtcol(".") <= vim.fn.indent(".") + 1
  local shouldCloseFold = vim.tbl_contains(vim.opt_local.foldopen:get(), "hor")
  if onIndentOrFirstNonBlank and shouldCloseFold then
    local wasFolded = pcall(vim.cmd.normal, "zc")
    if wasFolded then return end
  end
  vim.cmd.normal { "h", bang = true }
end, { desc = "h (+ close fold at BoL)" })
--- }}}

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.api.nvim_set_keymap('', "<space>", "<nop>", { noremap = true, silent = true })
function nnoremap(shortcut, command)
    vim.api.nvim_set_keymap("n", shortcut, command, { noremap = true, silent = true })
end
nnoremap("<leader>ev", ":tabedit $MYVIMRC<cr>")
nnoremap("<leader>sv", ":source $MYVIMRC<cr>")
