source $HOME/.config/zsh/aliases.d/taskwarrior.zsh
source $HOME/.config/zsh/aliases.d/backups.zsh

alias mv='mv -i'
alias cal='cal -m'

alias ls='exa'
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
alias hx="helix"
alias v="hx"

alias tms="python3 ~/projects/TMS/TMS2.py"

alias headphones="bluetoothctl power on && bluetoothctl connect 00:AD:D5:5A:5B:10"

alias xclip="xclip -selection c"

alias dvpon="setxkbmap -model pc104 -layout us,ru -variant dvp, -option grp:alt_shift_toggle"
alias dvpoff="setxkbmap -model pc104 -layout us,ru -option grp:alt_shift_toggle"

alias kitty-reload='kill -SIGUSR1 $(pgrep kitty)'

alias n="newsboat"

_SSHD_PATH=$(which sshd)
sshd() {
    if [[ -z $ANDROID_DATA ]]; then
        $_SSHD_PATH -f $HOME/.ssh/sshd_config -o Subsystem='sftp /usr/lib/ssh/sftp-server' $@
    else
        $_SSHD_PATH -f $HOME/.ssh/sshd_config -o Subsystem='sftp /data/data/com.termux/files/usr/libexec/sftp-server' $@
    fi
}

alias st="ssh tablet"
alias sp="ssh pc"

nsxiv() {
    xrdb -merge $HOME/.config/nsxiv/colors
    /usr/bin/nsxiv $@
}
