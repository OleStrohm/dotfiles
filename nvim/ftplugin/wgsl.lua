vim.cmd [[
nnoremap <buffer> <silent> <leader>m :FloatermNew --autoclose=0 --height=0.9 --width=0.9 --name=run cargo run<cr>
nnoremap <buffer> <silent> <leader>t :FloatermNew --autoclose=0 --height=0.9 --width=0.9 --name=test cargo test<cr>
]]
