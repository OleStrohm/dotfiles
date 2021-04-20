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

Plug 'camspiers/animate.vim'
Plug 'camspiers/lens.vim'
let g:lens#animate = 0

Plug 'tpope/vim-sensible'
Plug 'justinmk/vim-syntax-extra'
Plug 'sheerun/vim-polyglot'
Plug 'CaffeineViking/vim-glsl'
Plug 'ap/vim-css-color'
Plug 'voldikss/vim-floaterm'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
nnoremap <leader>o :GFiles --exclude-standard --others --cached<cr>

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'jackguo380/vim-lsp-cxx-highlight'

Plug 'itchyny/lightline.vim'
Plug 'dikiaap/minimalist'

Plug 'easymotion/vim-easymotion'
Plug 'preservim/nerdcommenter'
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDDefaultAlign = 'left'

Plug 'cespare/vim-toml'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'

call plug#end()
" }}}

" coc.nvim {{{
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <c-space> coc#refresh()

nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> [g <Plug>(coc-diagnostic-prev)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

nmap <leader>rn <Plug>(coc-rename)

command! -nargs=0 Format :call CocAction('format')

xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-cursor)

xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>ac  :w<cr><Plug>(coc-codeaction-cursor)

nmap <silent> <leader>qf  <Plug>(coc-fix-current)

xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>

nnoremap <silent> <space>sh :CocCommand clangd.switchSourceHeader<cr>
nnoremap <silent> <space>ssh :split<cr>:CocCommand clangd.switchSourceHeader<cr>
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
" Settings {{{
set nocompatible

set noshowmode

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

colorscheme minimalist

augroup fsharp_spaces
	autocmd!
	autocmd FileType fsharp set expandtab
augroup END

" }}}

" Abbreviations {{{
iabbrev flaot float
iabbrev heigth height
" }}}

" Mappings {{{
nnoremap <silent> <leader>w :write<cr>
nnoremap Q @q

nnoremap >i ddO

onoremap p i(
onoremap in( :<c-u>normal! f(vi(<cr>
onoremap il( :<c-u>normal! F)vi(<cr>

onoremap in" :<c-u>normal! f"vi"<cr>
onoremap il" :<c-u>normal! F"vi"<cr>

onoremap in' :<c-u>normal! f'vi'<cr>
onoremap il' :<c-u>normal! F'vi'<cr>
 
nnoremap <silent> <leader>c :nohlsearch<cr>

nnoremap - ddp
nnoremap _ kddpk
inoremap <C-d> <esc>ddi
inoremap <C-u> <esc>lviwUi
nnoremap <leader><C-u> viwU

nnoremap <leader>" viw<esc>a"<esc>bi"<esc>lel
vnoremap <leader>" <esc>`>a"<esc>`<i"<esc>lv`>l

inoremap jk <esc>

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

nnoremap <leader>ui ounimplemented!();<esc>
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
