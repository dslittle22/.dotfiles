set nocompatible

syntax on
set number
set relativenumber
set noswapfile
set ruler

set visualbell

set wrap
set textwidth=79
set formatoptions=tcqrn1
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround
set backspace=start

set ttyfast

set mouse=a

set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
filetype indent on
vnoremap . :norm.<CR>

packloadall

" search files recursively, using tab for completion
set path+=**
set wildmenu

" tweaks for netrw browser
let g:netrw_banner=0 " disbale banner
let g:netrw_browse_split=4
let g:netrw_altv=1 " open split to the right
let g:netrw_liststyle=3 " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',/(^/|/s/s/)/zs/./S/+' " wonder what this does

autocmd FileType c setlocal commentstring=//\ %s
autocmd FileType python setlocal commentstring=#\ %s
