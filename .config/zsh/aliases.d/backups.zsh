function backup_taskwarrior {
    tar cf ~/slow_ssd/backups/taskwarrior/task-backup-$(date +'%Y%m%d').tar ~/.local/share/task/*
    exa ~/slow_ssd/backups/taskwarrior/
}

function backup_newsboat {
    tar cf ~/slow_ssd/backups/rss/newsboat-backup-$(date +'%Y%m%d').tar ~/.config/newsboat/urls ~/.local/share/newsboat/*
    exa ~/slow_ssd/backups/rss/
}

backup_photodir() {(
    set -e
    PHOTO_DIR="${1%/}"

    if [[ "$(pwd)" != "$HOME/archive/photos" ]]; then
        # Hack for incompetent tar user
        echo "Current directory should be $HOME/archive/photos"
        return 1
    fi
    if [[ $# == 0 ]]; then
        echo "Directory for backup is not specified"
        return 2
    fi
    if [[ $# -gt 1 ]]; then
        echo "Excessive number of arguments"
        return 2
    fi

    echo "Archiving $PHOTO_DIR..."
    tar cf "$PHOTO_DIR.tar" $1
    echo "Finished archiving"

    echo "Getting password..."
    pass show -c backups
    echo "Password copied to clipboard"

    echo "Encrypting $PHOTO_DIR.tar..."
    gpg -c --cipher-algo AES256 --no-symkey-cache "$PHOTO_DIR.tar"
    echo "Finished encryption"

    echo "Starting backup to the second drive..."
    pv --force "$PHOTO_DIR.tar.gpg" > "$HOME/slow_ssd/archive/photos/$PHOTO_DIR.tar.gpg" &
    echo "Started"

    echo "Starting backup to the cloud..."
    rclone --verbose copy "$PHOTO_DIR.tar.gpg" yandex:archive/photos &
    echo "Started"

    echo "Waiting to finish..."
    wait
    echo "Backup finished"

    echo "Removing the archive..."
    rm "$PHOTO_DIR.tar"
    echo "$PHOTO_DIR.tar removed"

    echo "Removing gpg file..."
    rm "$PHOTO_DIR.tar.gpg"
    echo "$PHOTO_DIR.tar.gpg removed"

    echo "Success!"
)}
