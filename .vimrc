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
colorscheme sonokai

" search files recursively, using tab for completion
set path+=**
set wildmenu

autocmd FileType c setlocal commentstring=//\ %s
autocmd FileType python setlocal commentstring=#\ %s
autocmd FileType zsh setlocal commentstring=#\ %s
autocmd FileType vim setlocal commentstring=\"\ %s
