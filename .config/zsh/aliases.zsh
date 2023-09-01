alias mv='mv -i'
alias cal='cal -m'

alias ls='exa'
alias df='duf'
alias du='dust'
alias tree="tree -C"
alias cat='bat --style plain --paging never'

alias p="python3"
alias pdb="python3 -m pdb"

alias m="make"
alias mr="make run"

alias v="nvim"

alias t="task"
alias ta="task add"
alias tl="task list"
alias td="task done"
alias tm="task mod"
alias ti="task info"
alias te="task education"

alias tms="python3 ~/projects/TMS/TMS2.py"

alias headphones="bluetoothctl power on && bluetoothctl connect 00:AD:D5:5A:5B:10"

alias xclip="xclip -selection c"

alias dvpon="setxkbmap -model pc104 -layout us,ru -variant dvp, -option grp:alt_shift_toggle"
alias dvpoff="setxkbmap -model pc104 -layout us,ru -option grp:alt_shift_toggle"

alias kitty-reload='kill -SIGUSR1 $(pgrep kitty)'

alias n="newsboat"

alias sshd="$(which sshd) -f $HOME/.ssh/sshd_config"

nsxiv() {
    xrdb -merge $HOME/.config/nsxiv/colors
    /usr/bin/nsxiv $@
}
