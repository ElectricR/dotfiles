function backup_taskwarrior {
    tar cf ~/slow_ssd/backups/taskwarrior/task-backup-$(date +'%Y%m%d').tar ~/.local/share/task/*
    exa ~/slow_ssd/backups/taskwarrior/
}

function backup_newsboat {
    tar cf ~/slow_ssd/backups/rss/newsboat-backup-$(date +'%Y%m%d').tar ~/.config/newsboat/urls ~/.local/share/newsboat/*
    exa ~/slow_ssd/backups/rss/
}
