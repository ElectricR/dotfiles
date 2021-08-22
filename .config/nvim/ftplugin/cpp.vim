
set completeopt-=preview

nnoremap <silent> gd :call CocAction('jumpDefinition', 'tab drop')<CR>
" nmap <silent> gd <Plug>(coc-definition)

nmap <leader>rn <Plug>(coc-rename)
