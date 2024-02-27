while true; do
    nc -l localhost 44445 > ${TMPDIR}/tmp/kek
    xdg-open ${TMPDIR}/tmp/kek
    sleep 1;
done

