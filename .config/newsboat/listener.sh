#!/bin/bash

if ! pgrep -f 'nc -kl localhost 44444'; then
    exec 0>&-
    nc -kl localhost 44444 | xargs -L1 xdg-open
fi
