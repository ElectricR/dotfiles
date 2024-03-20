if ! pgrep Hyprland > /dev/null; then
    if which Hyprland > /dev/null; then
        exec Hyprland
    fi
fi
