function sudo {
    if [[ $1 == "nvim" ]]; then
        echo "Use sudoedit"
        return 1
    fi
    /sbin/sudo $@
}

function t() {
    if [[ $1 == "info" ]] || [[ $1 == "annotate" ]] || [[ $1 == "edit" ]]; then
        echo 'Use alias'
        return 1
    fi
    task $@
}

alias yadm="/bin/false" # Temporary for acquiring new habit
