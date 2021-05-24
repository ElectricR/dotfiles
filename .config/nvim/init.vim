filetype plugin indent on
set expandtab
set shiftwidth=4
set nocompatible
set tabstop=4
set smarttab

set ls=0

set number
highlight LineNr ctermfg=green

set hls
set is

" vim-plug begin
call plug#begin(stdpath('data') . '/plugged')

Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'ycm-core/YouCompleteMe'
" Plug 'ycm-core/YouCompleteMe', { 'do': './install.py --all --clangd-completer' }

" vim-plug end
call plug#end()

let g:ycm_global_ycm_extra_conf = ''

