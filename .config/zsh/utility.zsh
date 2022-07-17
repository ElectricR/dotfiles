# Directory management
setopt AUTO_PUSHD           # Push the current directory visited on the stack.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.
alias d='dirs -v'
for index ({1..100}) alias "$index"="cd +${index}"; unset index

# bd utility
source /usr/share/zsh/plugins/bd/bd.zsh

# Fast cd using fzf
fzfcd () {
    result=$(find | fzf --height 50% --reverse --border)
    if [[ -n "$result" ]]; then
        if [[ -f "$result" ]]; then
            cd $(dirname $result)
        else
            cd $result
        fi
    fi
}

bindkey -s '^f' 'fzfcd\n'
