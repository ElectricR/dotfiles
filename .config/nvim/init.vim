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
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' :'~/.vim/plugged')

Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'ycm-core/YouCompleteMe', { 'do': './install.py --clangd-completer' }

" vim-plug end
call plug#end()

