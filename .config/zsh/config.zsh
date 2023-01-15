# Load colors
autoload -U colors && colors

# Comments in interactive shell mode
setopt interactive_comments

# vi keys
bindkey -v
export KEYTIMEOUT=1

# Prompt
setopt PROMPT_SUBST
PROMPT_LEFT_BRACKET="%B%(?.%F{yellow}.%F{red})["
PROMPT_RIGHT_BRACKET="%B%(?.%F{yellow}.%F{red})]"
source $HOME/.config/zsh/host_specific.zsh
PROMPT_ICON="%(?.%B$PROMPT_HOST_SPECIFIC_ICON.%B%F{red} )"
PROMPT_EXIT="%F{white}%B -> "
PROMPT_PATH="%F{magenta}%~"
PROMPT="$PROMPT_LEFT_BRACKET%F{blue}$PROMPT_ICON $PROMPT_PATH$PROMPT_RIGHT_BRACKET$PROMPT_EXIT%f%b"
PROMPT_TIME="$PROMPT_LEFT_BRACKET%B%F{blue}%*$PROMPT_RIGHT_BRACKET"

precmd () {
    read NO_JOBS <<< $(jobs -p);
    if [ -z "$NO_JOBS" ]; then
        PROMPT_JOBS=""
    else
        PROMPT_JOBS="%B%F{red}  "
    fi
    unset NO_JOBS
    RPROMPT="$PROMPT_JOBS$PROMPT_TIME%b%f"
}

# History
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=$HOME/.config/zsh/.zhistory

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

# Edit line in editor with ctrl-e:
autoload edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
compinit
_comp_options+=(globdots)		# Include hidden files.

# Autosuggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
bindkey '^ ' autosuggest-accept

# Highlighting. Should be last.
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Ignore task command for adding in history
setopt histignorespace
