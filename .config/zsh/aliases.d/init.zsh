source $HOME/.config/zsh/aliases.d/taskwarrior.zsh
source $HOME/.config/zsh/aliases.d/backups.zsh

alias mv='mv -i'
alias cp='cp -i'
alias rm='rm -i'
alias cal='cal -m'

alias ls='eza'
alias df='duf'
alias du='dust'
alias tree="ls --tree"
alias cat='bat --style plain --paging never'

alias p="python3"
alias pdb="python3 -m pdb"

alias y="$(which yadm)"

alias m="make"
alias mr="make run"

#alias v="nvim"
if [ -n "$ANDROID_DATA" ]; then
    alias helix="$TERMUX_APP__FILES_DIR/usr/opt/helix/hx"
fi
alias hx="helix"
alias v="hx"

alias tms="python3 ~/projects/TMS/TMS2.py"

alias headphones="bluetoothctl power on && bluetoothctl connect 00:AD:D5:5A:5B:10"

alias xclip="xclip -selection c"

alias dvpon="setxkbmap -model pc104 -layout us,ru -variant dvp, -option grp:alt_shift_toggle"
alias dvpoff="setxkbmap -model pc104 -layout us,ru -option grp:alt_shift_toggle"

alias kitty-reload='kill -SIGUSR1 $(pgrep kitty)'

alias newsboat="newsboat --log-file /var/log/newsboat.log --log-level 4"
alias n="newsboat"
alias neomutt="TERM=xterm-direct neomutt"

nsxiv() {
    xrdb -merge $HOME/.config/nsxiv/colors
    /usr/bin/nsxiv $@
}

ssh() {
    if [ $1 = 'berry' ] || [ $1 = 'berry_wg' ]; then
        zsh ${HOME}/.config/neomutt/berry_port_map.sh &
        ${HOME}/.config/newsboat/listener.sh > /dev/null 2>/dev/null & disown
    fi

    if [ -n "$(lscpu | grep 5800X)" ]; then
        gpg-connect-agent updatestartuptty /bye > /dev/null
        print "Don't forget to press the key"
    fi
    /usr/bin/ssh $@
    if [ $1 = 'berry' ] || [ $1 = 'berry_wg' ]; then
        pkill -P $$ -f "berry_port_map.sh"
        pkill -f 'nc -l localhost 44445'
    fi
}
