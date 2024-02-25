while true; do
    nc -l localhost 44445 > /tmp/kek
    xdg-open /tmp/kek
    sleep 1;
done

