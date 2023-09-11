function sudo {
    if [[ $1 == "nvim" ]]; then
        echo "Use sudoedit"
        return 1
    fi
    /sbin/sudo $@
}
