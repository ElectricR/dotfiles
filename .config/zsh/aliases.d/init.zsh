source $HOME/.config/zsh/aliases.d/taskwarrior.zsh
source $HOME/.config/zsh/aliases.d/backups.zsh

alias mv='mv -i'
alias rm='rm -i'
alias cal='cal -m'

alias ls='eza'
alias df='duf'
alias du='dust'
alias tree="tree -C"
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

alias n="newsboat"

alias st="ssh tablet"
alias sp="ssh pc"

nsxiv() {
    xrdb -merge $HOME/.config/nsxiv/colors
    /usr/bin/nsxiv $@
}

ssh() {
    if [ $1 = 'berry' ] || [ $1 = 'berry_wg' ]; then
        nc -kl localhost 44444 | xargs -L1 xdg-open &
    fi

    if [ -n "$(lscpu | grep 5800X)" ]; then
        gpg-connect-agent updatestartuptty /bye > /dev/null
        print "Don't forget to press the key"
    fi
    /usr/bin/ssh $@
    if [ $1 = 'berry' ] || [ $1 = 'berry_wg' ]; then
        pkill -P $$ -f 'xargs -L1'
        pkill -P $$ -f 'nc -kl localhost 44444'
    fi
}
