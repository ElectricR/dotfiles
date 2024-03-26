#!/bin/zsh

nc -kl localhost 44444 | xargs -L1 xdg-open
