filetype plugin indent on

set expandtab
set shiftwidth=4
set nocompatible
set tabstop=4
set smarttab

set ls=0

" Bottom/top cursor indent
set scrolloff=8

set number relativenumber
highlight LineNr ctermfg=green

set hls
set is

call plug#begin(stdpath('data') . '/plugged')

    Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'jackguo380/vim-lsp-cxx-highlight'
    Plug 'jeffkreeftmeijer/vim-numbertoggle'

call plug#end()

set clipboard^=unnamed

" Completion remap
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

let mapleader=" "


