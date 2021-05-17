"" plugins
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sleuth'
Plug 'mtth/scratch.vim'
Plug 'luochen1990/rainbow'
Plug 'tpope/vim-rhubarb'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'ludovicchabant/vim-gutentags'
Plug 'vim-syntastic/syntastic'
Plug 'preservim/nerdcommenter'
Plug 'christoomey/vim-tmux-navigator' 
Plug 'SirVer/ultisnips'
Plug 'easymotion/vim-easymotion'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'fatih/vim-go'

Plug 'jpalardy/vim-slime', { 'for': 'python' }
Plug 'hanschen/vim-ipython-cell', { 'for': 'python' }
Plug 'mboughaba/i3config.vim'
Plug 'buoto/gotests-vim'

Plug 'tpope/vim-surround'
Plug 'ctrlpvim/ctrlp.vim'

Plug 'dense-analysis/ale'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

Plug 'fatih/molokai'

Plug 'rust-lang/rust.vim'


Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'preservim/tagbar'

Plug 'nathanaelkane/vim-indent-guides'
" nerdtree
Plug 'preservim/nerdtree' | Plug 'Xuyuanp/nerdtree-git-plugin'

Plug 'altercation/vim-colors-solarized'
call plug#end()

let mapleader = ","

map <leader><leader> <Plug>(easymotion-prefix)
let g:indent_guides_enable_on_vim_startup = 1


let g:AutoPairsToggleShortcut='ooooooooo'

let g:AutoPairsShortcutFastWrap=''
let g:AutoPairsShortcutJump=''
let g:AutoPairsShortcutBackInsert=''
"" ale

let g:ale_fix_on_save = 1
let g:ale_sign_column_always = 1
let g:airline#extensions#ale#enabled = 1

"" coc
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif
let g:go_doc_keywordprg_enabled = 0
" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" file searching and manouvering

nnoremap <F8> :TagbarToggle<CR>

" hide brackets on nerd tree git
let g:NERDTreeGitStatusConcealBrackets = 1
nnoremap <silent> <leader>n :NERDTreeToggle<cr>
nnoremap <silent><C-p><C-t> :CtrlPTag<cr>
nnoremap <silent><C-p><C-p> :CtrlP<cr>
nnoremap <silent><C-p><C-a> :CtrlPBufTag<cr>
" Open the existing NERDTree on each new tab.
"
set encoding=UTF-8

"" slime
let g:slime_target = "tmux"
let g:slime_default_config = {"socket_name": get(split($TMUX, ","), 0), "target_pane": ":.2"}



"" golang

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

let g:go_fmt_fail_silently = 0
let g:go_metalinter_autosave_enabled = ['all']
let g:go_jump_to_error = 1
let g:go_debug_windows = {
	\ 'vars':  'rightbelow 60vnew',
	\ 'out':  'botri 7new',
\ }
autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <leader>t  <Plug>(go-test)
autocmd FileType go nmap <leader>c <Plug>(go-coverage-toggle)

let g:go_debug_mappings = {
\ '(go-debug-continue)': {'key': 'c', 'arguments': '<nowait>'},
 \ '(go-debug-breakpoint)': {'key': 'M'},
\ '(go-debug-stop)': {'key': 'q'},
\ '(go-debug-next)': {'key': 'n', 'arguments': '<nowait>'},
\ '(go-debug-step)': {'key': 's'},
\ '(go-debug-restart)': {'key': 'L'},
\}
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1
let g:go_code_completion_enabled = 0



autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4


let g:go_fmt_command = "goimports"

autocmd Filetype go nmap <F2> <Plug>(go-rename)

autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')

"" general configuration


" Set to auto read when a file is changed form the outside
set autoread
au FocusGained,BufEnter * checktime

" map the leader to ,

" Fast saving
nnoremap <leader>w :w!<cr>

set wildmenu

set ruler
set nu rnu



noremap <leader>ev :tabe ~/.vimrc<cr>
noremap <leader>sv :source ~/.vimrc<cr>
set ignorecase
set smartcase
set hlsearch
set incsearch

set lazyredraw
set magic
set showmatch



set nobackup
set nowb
set noswapfile

set shiftwidth=4
set tabstop=4

map 0 ^

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l



set confirm
set dir=~/.cache/vim


set autowrite
let g:rehash256 = 1
let g:solarized_termcolors=256

let g:solarized_italic=1
colorscheme solarized

set updatetime=200

set mouse=a

let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'dir', 'rtscript',
                          \ 'undo', 'line', 'changes', 'mixed', 'bookmarkdir']

nmap <leader>: :!
set background=dark

let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size=1


let g:vim_markdown_math = 1


hi goFunction ctermfg=61 cterm=bold
hi goFunctionCall ctermfg=61 cterm=italic
hi goField ctermfg=125
hi goTypeName ctermfg=136 cterm=bold

noremap L $
noremap H ^

inoremap <C-BS> <C-w>
inoremap <C-h> <C-w>

inoremap <C-x> <esc>ddi
nnoremap <C-x> dd
vnoremap <C-x> d

let ExportedFunctionRegex = '\(\/\/.*\n\)\@<!\(func\s\(([a-zA-Z]\+\s\+\*\{0,1\}[A-Z][a-zA-Z0-9]*)\)\{0,1\}\|type\|const\)\s\+\zs[A-Z][a-zA-Z0-9]\+'

command! CommentNextUncommentedFunction call s:commentunexportedfunction(ExportedFunctionRegex) 

function! s:commentunexportedfunction(var) abort
    let @/=a:var
    :exe 'normal ygnO// '
    :exe 'normal p'
    :exe 'normal a '
    :startinsert
endfunction

nnoremap <leader>gc :CommentNextUncommentedFunction<cr>
 


let hs_highlight_delimiters = 1
let hs_highlight_boolean = 1
let hs_highlight_types = 1

let hs_highlight_more_types = 1
