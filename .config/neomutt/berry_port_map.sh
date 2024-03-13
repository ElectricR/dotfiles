function __get_tmp_dir() {
    if [[ -n $TMPDIR ]]; then
        echo ${TMPDIR::-4}
    else
        echo ""
    fi
}

while true; do
    nc -l localhost 44445 > $(__get_tmp_dir)/tmp/neomutt_berry_pre
    cp $(__get_tmp_dir)/tmp/neomutt_berry_pre $(__get_tmp_dir)/tmp/neomutt_berry
    xdg-open $(__get_tmp_dir)/tmp/neomutt_berry
    sleep 1;
done

