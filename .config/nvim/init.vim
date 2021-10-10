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
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'kyazdani42/nvim-tree.lua'

call plug#end()

set clipboard^=unnamed

let mapleader=" "

" GDB
" Add Esc as Terminal Mode exit
:nmap <leader>gdb :packadd termdebug<CR>:Termdebug<CR><C-w>b<C-w><S-H><C-w>l
:tnoremap <Esc> <C-\><C-n>
:nmap <leader>b :Break<CR>

"#########################################################
" Coc-NVim
"#########################################################
    set completeopt-=preview

    " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
    " delays and poor user experience.
    set updatetime=300

    " Highlight the symbol and its references when holding the cursor.
    autocmd CursorHold * silent call CocActionAsync('highlight')

    " Go to definition
    nnoremap <silent> gd :call CocAction('jumpDefinition', 'tab drop')<CR>

    " Error jumps
    nmap <silent> g[ <Plug>(coc-diagnostic-prev)
    nmap <silent> g] <Plug>(coc-diagnostic-next)

    " Use K to show documentation in preview window.
    nnoremap <silent> K :call <SID>show_documentation()<CR>

    function! s:show_documentation()
      if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
      elseif (coc#rpc#ready())
        call CocActionAsync('doHover')
      else
        execute '!' . &keywordprg . " " . expand('<cword>')
      endif
    endfunction

    " Rename symbol
    nmap <leader>rn <Plug>(coc-rename)

    " Formatting selected code.
    xmap <leader>f  <Plug>(coc-format-selected)
    nmap <leader>f  <Plug>(coc-format-selected)

    " Completion remap
    inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

"#########################################################

