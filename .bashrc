# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'


# Mine
alias s="sudo pm-suspend"
# alias puml="java -jar /home/er/Downloads/plantuml.jar"
# alias n='[ $(gsettings get org.gnome.settings-daemon.plugins.color night-light-enabled) = true ] && gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled false || gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true'
alias p="python3"
alias pdb="python3 -m pdb"
alias m="make"
alias mr="make run"
alias mb="make build"
alias md="make debug"
alias mt="make test"
alias v="nvim"
alias tms="python3 ~/PROJECTS/TMS/TMS2.py"
alias c="clear"
alias g="git"
alias xclip="xclip -selection c"
