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

" Plugins will be downloaded under the specified directory.
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' :'~/.vim/plugged')

" Declare the list of plugins.
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}

function! BuildYCM(info)  
  " info is a dictionary with 3 fields  
  " - name:   name of the plugin  
  " - status: 'installed', 'updated', or 'unchanged'  
  " - force:  set on PlugInstall! or PlugUpdate!  
  if a:info.status == 'installed' || a:info.force  
    !./install.py --clangd-completer
  endif  
endfunction

Plug 'ycm-core/YouCompleteMe', { 'do': function('BuildYCM') }

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

