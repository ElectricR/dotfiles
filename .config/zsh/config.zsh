# I am so tired of kitty
export TERM=xterm-256color

# I am so tired of gdb
unset DEBUGINFOD_URLS

# Smartcard SSH
export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

# Let's put EDITOR here...
export EDITOR=helix

# XDG
export XDG_DATA_HOME="$HOME/.local/share"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/pass"

# Load colors
autoload -U colors && colors

# Comments in interactive shell mode
setopt interactive_comments

# vi keys
bindkey -v
export KEYTIMEOUT=1

# History
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=$XDG_DATA_HOME/zsh/.zhistory

# Add GO binaries
PATH=$PATH:$HOME/go/bin/

# Disable ctrl-s to freeze terminal.
stty stop undef		

# Use vim keys in tab complete menu:
zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# Increase/Decrease number under cursor
autoload -U incarg
decarg() {
    NUMERIC="-1"
    incarg
}
zle -N incarg
zle -N decarg
bindkey '^a' incarg '^x' decarg
bindkey -M vicmd '^a' incarg '^x' decarg
bindkey -M visual '^a' incarg '^x' decarg

# Change cursor shape for zsh (openssh issues)
# Source: https://unix.stackexchange.com/questions/433273/changing-cursor-style-based-on-mode-in-both-zsh-and-vim
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'

  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
_fix_cursor() {
   echo -ne '\e[5 q'
}
precmd_functions+=(_fix_cursor)

# Edit line in editor with ctrl-e:
autoload edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line
bindkey -M vicmd '^e' edit-command-line

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
compinit
_comp_options+=(globdots)		# Include hidden files.

# Vim brackets and quotes text objects
autoload -Uz select-bracketed select-quoted
zle -N select-quoted
zle -N select-bracketed
for km in viopp visual; do
  bindkey -M $km -- '-' vi-up-line-or-history
  for c in {a,i}${(s..)^:-\'\"\`\|,./:;=+@}; do
    bindkey -M $km $c select-quoted
  done
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
    bindkey -M $km $c select-bracketed
  done
done

# Autosuggestions
source $HOME/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
bindkey '^ ' autosuggest-accept

# Highlighting. Should be last.
source $HOME/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Ignore task command for adding in history
setopt histignorespace

# Force bottom prompt
function bottom_prompt {
  tput cup $(($LINES-1)) 0
}
add-zsh-hook precmd bottom_prompt

# p10k
source $HOME/.config/zsh/plugins/zsh-powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

