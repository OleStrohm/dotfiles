vim.cmd [[
tnoremap <esc> <C-\><C-n>
nnoremap <buffer> <silent> <leader>m :FloatermNew --autoclose=0 --height=0.9 --width=0.9 --name=run python %<cr>
]]
