filetype plugin indent on
set expandtab
set shiftwidth=4
set tabstop=4
set smarttab

set ls=0

set number
highlight LineNr ctermfg=green

set hls
set is

" Plugins will be downloaded under the specified directory.
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' :'~/.vim/plugged')

" Declare the list of plugins.
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}

" List ends here. Plugins become visible to Vim after this call.
call plug#end()
