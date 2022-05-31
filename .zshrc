source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

alias vpn='nmcli connection up YandexVPN'
alias shot='flameshot gui'

alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Mine
alias s="sudo pm-suspend"
# alias puml="java -jar /home/er/Downloads/plantuml.jar"
alias n='[ $(gsettings get org.gnome.settings-daemon.plugins.color night-light-enabled) = true ] && gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled false || gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true'
alias p="python3"
alias pdb="python3 -m pdb"
alias m="make"
alias mr="make run"
alias mb="make build"
alias md="make debug"
alias mt="make test"
alias v="nvim"
alias tms="python3 ~/projects/TMS/TMS2.py"
alias c="clear"
alias g="git"
alias xclip="xclip -selection c"
alias headphones="bluetoothctl connect 00:AD:D5:5A:5B:10"

# Enable colors and change prompt:
autoload -U colors && colors	# Load colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%} %{$fg[blue]%}% %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
setopt autocd		# Automatically cd into typed directory.
stty stop undef		# Disable ctrl-s to freeze terminal.
setopt interactive_comments

HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=~/.zsh_history

# History binds
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
bindkey "^R" history-beginning-search-backward-end

# Load aliases and shortcuts if existent.
#[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc"
#[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"
#[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc"

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp" >/dev/null
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'lfcd\n'

#bindkey -s '^a' 'bc -lq\n'

bindkey -s '^f' 'v "$(fzf)"\n'

#bindkey '^[[P' delete-char

# Edit line in vim with ctrl-e:
#autoload edit-command-line; zle -N edit-command-line
#bindkey '^e' edit-command-line

# The next line updates PATH for Yandex Cloud CLI.
if [ -f '/home/roman-chulkov/yandex-cloud/path.bash.inc' ]; then source '/home/roman-chulkov/yandex-cloud/path.bash.inc'; fi

# The next line enables shell command completion for yc.
if [ -f '/home/roman-chulkov/yandex-cloud/completion.zsh.inc' ]; then source '/home/roman-chulkov/yandex-cloud/completion.zsh.inc'; fi

source <(kubectl completion zsh)
source <(helm completion zsh)
alias k=kubectl
alias h=helm
bindkey '^ ' autosuggest-accept
alias wk="watch --color kubecolor --force-colors"
compdef wk=kubectl
watch_kube (){
    prefix="wk"
    if [ ${BUFFER%% *} = "k" ]; then
        BUFFER="$prefix ${BUFFER#* }"
        zle accept-line
    fi
}
zle -N watch_kube
bindkey "^w" watch_kube

PATH=${PATH}:${HOME}/go/bin

# Load syntax highlighting; should be last.
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh 2>/dev/null

