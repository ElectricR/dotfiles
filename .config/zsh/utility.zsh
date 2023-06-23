# Directory management
setopt AUTO_PUSHD           # Push the current directory visited on the stack.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.
alias d='dirs -v'
for index ({1..100}) alias "$index"="cd +${index}"; unset index

# bd utility
source $HOME/.config/zsh/plugins/bd.zsh

# Fast cd using fzf
export FZF_DEFAULT_OPTS='--height 50% --reverse --border'
fzfcd () {
    result=$(find | fzf)
    if [[ -n "$result" ]]; then
        if [[ -d "$result" ]]; then
            cd $result
        else
            cd $(dirname $result)
        fi
    fi
}
bindkey -s '^f' 'fzfcd\n'

# CTRL-T and CTRL-R shortcuts for fzf
source $HOME/.config/zsh/plugins/fzf/key-bindings.zsh
