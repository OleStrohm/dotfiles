vim.cmd([[
call plug#begin('~/.config/nvim/plugged')

Plug 'dstein64/vim-startuptime'

" nvim-lsp
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp_extensions.nvim'

" Completion
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" Completion snippets
Plug 'SirVer/ultisnips'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'

" extra highlighting
Plug 'CaffeineViking/vim-glsl'
Plug 'ap/vim-css-color'
Plug 'cespare/vim-toml'
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
]])
