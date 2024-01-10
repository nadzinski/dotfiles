set nocompatible " turn off vi compatability

" detect OS
if has("unix")
    if system("uname")  == "Darwin\n"
        let os_type = "OSX"
    elseif system("uname") == "Linux\n"
        let os_type = "LINUX"
    else
        let os_type = "OTHER"
    endif
endif

execute pathogen#infect()

syntax on
filetype plugin indent on

" runtime path
set rtp+=~/.fzf     " fzf fuzzy finder

" ===== Status Information =====
set number              " line numbers
set cursorline          " Highlight current line
set ruler               " Show position in file
set showcmd             " show command in bottom bar
set laststatus=2        " Always display statusline
set statusline=%f       " relative path
set statusline+=\ (%{FugitiveStatusline()})    " branch or commit hash
set statusline+=\ %h    " help buffer flag
set statusline+=%w      " preview window flag
set statusline+=%m      " modified flag
set statusline+=%r      " read only flag
set statusline+=\ %=    " right align 
" start item group; line #; col #; align within group; percentage, end group
set statusline+=%(%l,%c\ %=\ %P%)
set statusline+=%*      " restore normal highlight
 
" ===== Search =====
set hlsearch   " Search match highlighting
set ignorecase " Case insensitive...
set smartcase  " ... except if search term includes caps
set incsearch  " Incremental search

set backspace=indent,eol,start

set mouse=a     " scrollwheel

set wildmenu    " visual autocomplete for command menu

" Remove trailing whitespace on write
autocmd BufWritePre *.py,*.js,*.hs,*.html,*.css,*.scss :%s/\s\+$//e

" Save undos so we have access to them when we reopen files
set undofile
set undodir=~/.vim/undodir//


" ===== Clipboard =====
" use system clipboard
if os_type == "OSX"
    set clipboard=unnamed 
else 
    " Linux
    set clipboard=unnamedplus 
endif

" ===== Keyboard mappings =====

" Remap leader to space
noremap <space> <nop>
let mapleader = "\<space>"

"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Remap arrow keys to nothing
" Normal mode
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
" Insert mode
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" New tab 
map <leader>t :tabnew<CR>

" Nerdtree
map <leader>r :NERDTreeToggle<CR>

" fzf fuzzy search
nnoremap <leader>f :Files<cr>

" grep for word under cursor
nnoremap <C-a> :!ag <cword><CR>

" ===== Color Scheme =====
colorscheme badwolf

" ===== Language dependent =====

" Defaults
set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4

autocmd Filetype python 
                \set tabstop=4 |
                \set softtabstop=4 |
                \set shiftwidth=4 |
                \set expandtab |
                \set encoding=utf-8 |
                \nnoremap <buffer> <leader>d oimport ipdb; ipdb.set_trace()<esc>^

autocmd Filetype javascript
            \ set tabstop=2 |
            \ set softtabstop=2 |
            \ set shiftwidth=2
let g:jsx_ext_required = 0  " jsx highlighting for .js files
 
autocmd Filetype html
            \ set tabstop=2 |
            \ set softtabstop=2 |
            \ set shiftwidth=2
 
autocmd Filetype css
            \ set tabstop=2 |
            \ set softtabstop=2 |
            \ set shiftwidth=2

autocmd Filetype sls
            \ setlocal shiftwidth=4 tabstop=4 softtabstop=4 

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_loc_list_height = 5


let g:syntastic_python_checkers = ['flake8']
let g:syntastic_python_flake8_args="--exclude="

nnoremap <leader>m :SyntasticCheck mypy<cr>
let g:syntastic_python_mypy_args="--show-error-codes --follow-imports=silent --ignore-missing-imports --namespace-packages"

" Ale
let g:ale_open_list = 'on_save'
let g:ale_list_window_size = 5
augroup CloseLoclistWindowGroup
  autocmd!
  autocmd QuitPre * if empty(&buftype) | lclose | endif
augroup END

" Gvim specific
if has("gui_running")
  syntax enable
  set lines=35 columns=100
  set guioptions-=T  "remove toolbar
  set guioptions-=r  "remove right-hand scroll bar
  set guioptions-=l  "remove right-hand scroll bar
  set guicursor+=n-v-c:blinkon0
  set guifont=Monospace\ 12
endif

" Send all yanks to system clipboard
let g:oscyank_silent = v:true
autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' && exists(":OSCYankRegister") | execute 'OSCYankRegister "' | endif
