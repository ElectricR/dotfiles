exit 1 # Remove once ctrl+shift+e inhabited
source $HOME/.config/zsh/palette.zsh
nvim -n \
    -c "set nonumber nolist norelativenumber showtabline=0 foldcolumn=0" \
    -c "autocmd TermOpen * normal G" \
    -c "map <silent> q :qa!<CR>" \
    -c "silent write! /tmp/kitty_scrollback_buffer" \
    -c "te head -q -n-1 /tmp/kitty_scrollback_buffer; rm /tmp/kitty_scrollback_buffer; cat"
