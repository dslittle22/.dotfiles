set nocompatible

syntax on
set number
set relativenumber
set noswapfile
set ruler

set visualbell

set wrap
set formatoptions=tcqrn1
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround
set backspace=start,eol,indent

set ttyfast

set mouse=a

set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
filetype indent on
vnoremap . :norm.<CR>


:set termguicolors
set autoread


" search files recursively, using tab for completion
" set path+=**
" set path+=**20
set wildmenu
set wildmode=list:longest,full
" set wildignore+=*/node_modules/*,_site,*/__pycache__/,*/venv/*,*/target/*,*/.vim,*/.log,*/.out

autocmd FileType c setlocal commentstring=//\ %s
autocmd FileType python setlocal commentstring=#\ %s
autocmd FileType zsh setlocal commentstring=#\ %s
autocmd FileType vim setlocal commentstring=\"\ %s
:set scrolloff=10

nnoremap <SPACE> <Nop>
nnoremap "<C-d>" "<C-d>zz"
nnoremap "<C-u>" "<C-u>zz"
let mapleader=" "

" override surround plugin mappings
let g:surround_no_mappings = 1

nmap ds  <Plug>Dsurround
nmap cs  <Plug>Csurround
nmap ys  <Plug>Ysurround
nmap yS  <Plug>YSurround

nmap ySs <Plug>YSsurround
nmap ySS <Plug>YSsurround
" xmap S   <Plug>VSurround
xmap gS  <Plug>VgSurround

if !hasmapto("<Plug>Isurround","i") && "" == mapcheck("<C-S>","i")
  imap    <C-S> <Plug>Isurround
endif
imap      <C-G>s <Plug>Isurround
imap      <C-G>S <Plug>ISurround

packloadall
colorscheme sonokai
