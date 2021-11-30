" Settings {{{
set nocompatible

set noshowmode
set completeopt=menuone,noinsert,noselect
set shortmess+=c

syntax on
filetype plugin indent on

set modelines=0
set wrap
set whichwrap+=<,>,[,]

set scrolloff=5
set ttyfast
set laststatus=2

set autoindent
set showmode
set showcmd
set number
set cursorline

set hlsearch
set incsearch
set ignorecase
set smartcase

set splitright splitbelow

set ts=4
set tabstop=4 shiftwidth=4 expandtab

set signcolumn=yes

" }}}

" Command Customization {{{
let mapleader = ","
let maplocalleader = "\\"

nnoremap <silent> <leader>ev :sp $MYVIMRC<cr>
nnoremap <silent> <leader>sv :source $MYVIMRC<cr>

augroup filetype_vim
	autocmd!
	autocmd FileType vim setlocal foldmethod=marker
augroup END

augroup AUTOSAVE
	autocmd!
	autocmd InsertLeave *.rs ++nested write
augroup END

set exrc
set secure

set updatetime=300

" }}}

" Plugins {{{
call plug#begin('~/.config/nvim/plugged')

" nvim-lsp
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp_extensions.nvim'

" Completion
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" Completion snippets
Plug 'SirVer/ultisnips'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'

" extra highlighting
Plug 'tpope/vim-sensible'
Plug 'justinmk/vim-syntax-extra'
Plug 'sheerun/vim-polyglot'
Plug 'CaffeineViking/vim-glsl'
Plug 'ap/vim-css-color'
Plug 'cespare/vim-toml'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'

Plug 'voldikss/vim-floaterm'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
nnoremap <leader>o :GFiles --exclude-standard --others --cached<cr>

Plug 'itchyny/lightline.vim'
Plug 'dikiaap/minimalist'

" Don't really use it
Plug 'easymotion/vim-easymotion'

call plug#end()

colorscheme minimalist
" }}}

" {{{ Plugin settings
set completeopt=menu,menuone,noselect

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "lua", "rust" },
  highlight = { enable = true, },
  indent = { enable = true },
}

-- Set up nvim-cmp {{{
local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  mapping = {
    ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'ultisnips' }, -- For ultisnips users.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})
-- }}}

local nvim_lsp = require'lspconfig'

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local on_attach = function(client, bufnr)
-- lsp keymaps {{{
	local function buf_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
	local opts = { noremap=true, silent=true }

	buf_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<cr>', opts)
	buf_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)

	buf_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
	buf_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
	buf_keymap('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
	buf_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
	buf_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
	buf_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
	buf_keymap('n', '<space>o', '<cmd>lua vim.lsp.buf.document_symbol()<cr>', opts)

	buf_keymap('n', 'g[', '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>', opts)
	buf_keymap('n', 'g]', '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>', opts)
	buf_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
-- }}}
end

nvim_lsp.rust_analyzer.setup({
    on_attach=on_attach,
    capabilities = capabilities,
    settings = {
        ["rust-analyzer"] = {
            assist = {
                importGranularity = "module",
                importPrefix = "by_self",
            },
            cargo = {
                loadOutDirsFromCheck = true
            },
            procMacro = {
                enable = true
            },
        }
    }
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    update_in_insert = true,
  }
)
EOF

autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *
            \ lua require'lsp_extensions'.inlay_hints{ prefix = '', highlight = "Comment", enabled = {"TypeHint", "ChainingHint", "ParameterHint"} }
" }}}

" Custom compilations {{{
let g:floaterm_autoclose = 1
augroup FLOATERM_COMPILATIONS
	autocmd!
	autocmd FileType fsharp nnoremap <buffer> <silent> <leader>m :FloatermNew --autoclose=0 --height=0.9 --width=0.9 --name=run dotnet run<cr>
	autocmd FileType rust nnoremap <buffer> <silent> <leader>m :FloatermNew --autoclose=1 --height=0.9 --width=0.9 --name=run cargo run<cr>
	autocmd FileType rust nnoremap <buffer> <silent> <leader>M :FloatermNew --autoclose=0 --height=0.9 --width=0.9 --name=run cargo run<cr>
	autocmd FileType rust nnoremap <buffer> <silent> <leader>t :FloatermNew --autoclose=0 --height=0.9 --width=0.9 --name=test cargo test<cr>
	autocmd FileType cpp nnoremap <buffer> <silent> <leader>m :FloatermNew --autoclose=1 --height=0.9 --width=0.9 --name=run make test<cr>
	autocmd FileType cpp nnoremap <buffer> <silent> <leader>M :FloatermNew --autoclose=0 --height=0.9 --width=0.9 --name=run make test<cr>
	autocmd FileType arduino nnoremap <buffer> <silent> <leader>m :FloatermNew --autoclose=0 --height=0.9 --width=0.9 --name=run arduino-cli compile --fqbn STM32:stm32:Nucleo_32:pnum=NUCLEO_L432KC starter && arduino-cli upload -p /dev/ttyACM0 --fqbn STM32:stm32:Nucleo_32:pnum=NUCLEO_L432KC,upload_method=swdMethod starter<cr>
	autocmd FileType verilog nnoremap <buffer> <silent> <leader>m :FloatermNew --autoclose=0 --height=0.9 --width=0.9 --name=test ./run_tb.sh<cr>
augroup END
" }}}

nmap s <Plug>(easymotion-overwin-f2)
" Mappings {{{
nnoremap <silent> <leader>w :write<cr>
nnoremap Q @q

nnoremap <silent> <leader>c :nohlsearch<cr>

" terminal
nnoremap <leader>T :split<cr>:terminal<cr>i
tnoremap <esc> <C-\><C-n>
tnoremap jk <esc>
tnoremap <M-[> <esc>
autocmd FileType fzf tmap <buffer> <esc> <esc>

" Movement
tnoremap <M-h> <c-\><c-n><c-w>h
tnoremap <M-j> <c-\><c-n><c-w>j
tnoremap <M-k> <c-\><c-n><c-w>k
tnoremap <M-l> <c-\><c-n><c-w>l
inoremap <M-h> <Esc><c-w>h
inoremap <M-j> <Esc><c-w>j
inoremap <M-k> <Esc><c-w>k
inoremap <M-l> <Esc><c-w>l
vnoremap <M-h> <Esc><c-w>h
vnoremap <M-j> <Esc><c-w>j
vnoremap <M-k> <Esc><c-w>k
vnoremap <M-l> <Esc><c-w>l
nnoremap <M-h> <c-w>h
nnoremap <M-j> <c-w>j
nnoremap <M-k> <c-w>k
nnoremap <M-l> <c-w>l
" }}}

" Plugin dev {{{
set conceallevel=2 concealcursor=nv
call clearmatches()

function JumpPrompt()
	redraw
	nohlsearch
	echo ">"
	let l:cin = nr2char(getchar())
	let l:search = l:cin
	redraw
	echo ">" . l:search
	let l:cin = nr2char(getchar())
	let l:search = l:search . l:cin
	redraw
	echo ">" . l:search
	highlight JumpDeEmphasize ctermfg=darkgrey
	highlight Conceal ctermfg=red ctermbg=NONE
	let l:himatches = []
	call add(l:himatches, matchadd("JumpDeEmphasize", ".*", 1))
	call add(l:himatches, matchadd('Conceal', '\c' . l:search[0] . '\zs' . l:search[1], 3, -1, { 'conceal': '_' }))
	redraw
	let l:top = line('w0')
	let l:bot = line('w$')
	let l:matches = []

	let l:i = l:top
	for l:i in range(l:top, l:bot)
		let l:line = getline(l:i)

		let l:match = matchstrpos(l:line, '\c' . l:search)
		while l:match[1] >= 0
			call add(l:matches, [l:i, l:match[1] + 1])
			let l:match = matchstrpos(l:line, '\c' . l:search, l:match[2])
		endwhile
	endfor

	let l:alphabet = "f;sd,oem"
	let l:jumpMap = {}

	echo ceil(len(l:matches)/len(l:alphabet))

	for l:i in range(0, len(l:matches)-1)
		let l:jumpMap[l:alphabet[l:i]] = l:matches[l:i]
		call add(l:himatches, matchadd('Conceal', '\%' . l:matches[l:i][0] . 'l\%' . l:matches[l:i][1] . 'c', 3, -1, { 'conceal': l:alphabet[l:i/ceil(len(l:matches)/len(l:alphabet))] }))
	endfor
	redraw!

	let l:jumpchar = nr2char(getchar())
	if stridx(l:alphabet, l:jumpchar) >= 0
		let l:pos = getpos('.')
		let l:pos[1] = l:jumpMap[l:jumpchar][0]
		let l:pos[2] = l:jumpMap[l:jumpchar][1]
		call setpos('.', l:pos)

		while len(l:himatches) > 0
			call matchdelete(l:himatches[0])
			call remove(l:himatches, 0)
		endwhile
	endif
	redraw
	echo ""

	" Use matchaddpos (may be more efficient, maximum 8)
	" Would require a alphabet of length 8 and putting all similar
	" position into one match.
	" call matchaddpos('Conceal', [[5, 5]], 4, -1, { 'conceal': 'f' })
endfunction
" }}}

" Custom commands {{{
command! Test w | silent !./test.sh
noremap <leader><F2> :Test<cr>
" }}}
