function __backup_get_date_suffix {
    echo "$(date +'%Y%m%d')"
}

function __backup_remote_archive_with_cd {
    if [ -f "$HOME/slow_ssd/backups/$2/$2-backup-$3.tar" ]; then
        echo "Local backup already exists"
        return
    fi
    echo "Creating backup..."
    ssh $1 "tar cf $2-backup-$3.tar -C $4 ${@:5}"
    echo "Backup created"
    echo "Copying backup to disk..."
    scp "$1:$2-backup-$3.tar" "$HOME/slow_ssd/backups/$2/"
    echo "Backup copied"
    echo "Removing archive from berry..."
    ssh $1 "rm $2-backup-$3.tar"
    echo "Removed"
}

function __backup_local_archive {
    if [ -f "$HOME/slow_ssd/backups/$1/$1-backup-$2.tar" ]; then
        echo "Local backup already exists"
        return
    fi
    echo "Creating backup..."
    tar cf "$1-backup-$2.tar" -C $3 "${@:4}"
    echo "Backup created"
    echo "Copying backup to disk..."
    cp "$1-backup-$2.tar" "$HOME/slow_ssd/backups/$1/"
    echo "Backup copied"
    echo "Removing archive..."
    rm "$1-backup-$2.tar"
    echo "Removed"
}

function __backup_encrypt_archive {
    if [ -f "$2.gpg" ]; then
        echo "gpg file already exists"
        return
    fi
    echo "Getting password..."
    pass show -c backups
    echo "Password copied to clipboard"
    echo 'Encrypting...'
    gpg -c -o "$2.gpg" --cipher-algo AES256 --no-symkey-cache "$1/$2"
    echo "Finished encryption"
}

function __backup_upload_gpg {
    echo "Starting upload..."
    rclone --verbose copy $2 yandex:/backups/$1/
    echo "Uploaded"
    echo "Removing gpg..."
    rm "$2"
    echo "Removed"
}

backup_zhistory() {
    datename=$(__backup_get_date_suffix)
    __backup_local_archive zhistory "pc-$datename" "$HOME/.local/share/zsh" ".zhistory"
    for host in berry rasp overseer; do
        __backup_remote_archive_with_cd $host zhistory "$host-$datename" "~/.local/share/zsh" .zhistory
    done
    for host in pc berry rasp overseer; do
        __backup_encrypt_archive "$HOME/slow_ssd/backups/zhistory" "zhistory-backup-$host-$datename.tar"
    done
    for host in pc berry rasp overseer; do
        __backup_upload_gpg zhistory "zhistory-backup-$host-$datename.tar.gpg"
    done
    echo 'Finished'
}

backup_taskwarrior() {
    datename=$(__backup_get_date_suffix)
    __backup_remote_archive_with_cd berry taskwarrior $datename "~/.local/share" task
    __backup_encrypt_archive "$HOME/slow_ssd/backups/taskwarrior" "taskwarrior-backup-$datename.tar"
    __backup_upload_gpg taskwarrior "taskwarrior-backup-$datename.tar.gpg"
    echo "Finished"
}

backup_newsboat() {
    datename=$(__backup_get_date_suffix)
    __backup_remote_archive_with_cd berry newsboat $datename "~" ".config/newsboat/urls" ".local/share/newsboat/*"
    __backup_encrypt_archive "$HOME/slow_ssd/backups/newsboat" "newsboat-backup-$datename.tar"
    __backup_upload_gpg newsboat "newsboat-backup-$datename.tar.gpg"
    echo "Finished"
}

backup_osu() {
    datename=$(__backup_get_date_suffix)
    __backup_local_archive osu $datename "$HOME" "osu"
    __backup_encrypt_archive "$HOME/slow_ssd/backups/osu" "osu-backup-$datename.tar"
    echo 'osu backup creation is done, now do manual upload and remove gpg file'
}

backup_music() {
    echo 'Starting rsync...'
    rsync -rv --delete --progress phone:storage/music/ ~/fast_ssd/backups/music
    echo 'Finished rsync'
    echo 'Starting archiving...'
    tar cf "music-backup-$(date +'%Y%m%d').tar" ~/fast_ssd/backups/music
    echo 'Archive created'

    __encrypt_for_backup "music-backup-$(date +'%Y%m%d').tar"

    echo 'Removing temporary archive...'
    rm "music-backup-$(date +'%Y%m%d').tar"
    echo 'Removed'
    echo 'Music backup creation is done, now do manual upload and remove gpg file'
}

backup_photodir() {(
    echo 'Outdated'
    return 1
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

    # TODO: Use __encrypt_for_backup
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
