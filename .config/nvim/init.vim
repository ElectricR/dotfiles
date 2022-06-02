filetype plugin indent on

set expandtab
set shiftwidth=4
set nocompatible
set tabstop=4
set smarttab

set ls=0
set cmdheight=2

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
    Plug 'lervag/vimtex'
    Plug 'sonph/onehalf', { 'rtp': 'vim' }
    Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-telescope/telescope-fzy-native.nvim'
    Plug 'luochen1990/rainbow'

call plug#end()

set clipboard^=unnamed

let g:rainbow_active = 1

let mapleader=" "

" GDB
" Add Esc as Terminal Mode exit
:nmap <leader>gdb :packadd termdebug<CR>:Termdebug<CR><C-w>b<C-w><S-H><C-w>l
:tnoremap <Esc> <C-\><C-n>
:nmap <leader>b :Break<CR>

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
noremap <C-f> <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

"#########################################################
" Coc-NVim
"#########################################################
    "#########################################################
    " Go
    "#########################################################
    let g:go_def_mapping_enabled = 0

    let g:go_highlight_functions = 1
    let g:go_highlight_function_calls = 1
    let g:go_highlight_extra_types = 1
    let g:go_highlight_generate_tags = 1
    let g:go_highlight_fields = 1
    let g:go_highlight_types = 1
    let g:go_highlight_structs = 1 
    let g:go_highlight_methods = 1
    let g:go_highlight_functions = 1
    let g:go_highlight_operators = 1
    let g:go_highlight_build_constraints = 1

    "#########################################################
    set completeopt-=preview

    " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
    " delays and poor user experience.
    set updatetime=300

    " Highlight the symbol and its references when holding the cursor.
    autocmd CursorHold * silent call CocActionAsync('highlight')

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

    " Show code action alternatives
    nmap <leader>a  <Plug>(coc-codeaction)

    " Apply AutoFix to problem on the current line.
    nmap <leader>qf  <Plug>(coc-fix-current)

    " Completion remap
    function! s:check_back_space() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~ '\s'
    endfunction
    inoremap <silent><expr> <Tab>
          \ pumvisible() ? "\<C-n>" :
          \ <SID>check_back_space() ? "\<Tab>" :
          \ coc#refresh()
    inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-P>" : "\<C-H>"
    inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<CR>"
    inoremap <silent><expr> <c-space> coc#refresh()

    " Map 'around' and 'inside' selections for functions and classes
    " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
    xmap if <Plug>(coc-funcobj-i)
    omap if <Plug>(coc-funcobj-i)
    xmap af <Plug>(coc-funcobj-a)
    omap af <Plug>(coc-funcobj-a)
    xmap ic <Plug>(coc-classobj-i)
    omap ic <Plug>(coc-classobj-i)
    xmap ac <Plug>(coc-classobj-a)
    omap ac <Plug>(coc-classobj-a)

    " Remap <C-f> and <C-b> for scroll float windows/popups.
    " if has('nvim-0.4.0') || has('patch-8.2.0750')
    "     nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    "     nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    "     inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
    "     inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
    "     vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    "     vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    " endif

    " Go to definitions
    nnoremap <silent> gd :call CocAction('jumpDefinition', 'tab drop')<CR>
    nmap <silent> gr <Plug>(coc-references)

    " Error jumps
    nmap <silent> g[ <Plug>(coc-diagnostic-prev)
    nmap <silent> g] <Plug>(coc-diagnostic-next)
"#########################################################

"#########################################################
" Theming
"#########################################################
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

"colorscheme onehalfdark
"#########################################################
