function __get_tmp_dir() {
    if [[ -n $TMPDIR ]]; then
        echo ${TMPDIR::-4}
    else
        echo ""
    fi
}

while true; do
    nc -l localhost 44445 > $(__get_tmp_dir)/tmp/kek
    xdg-open $(__get_tmp_dir)/tmp/kek
    sleep 1;
done

