#!/usr/bin/env bash

export PRIMARY_DISPLAY="$(xrandr | awk '/ primary/{print $1}')"

xidlehook \
    --not-when-fullscreen \
    --not-when-audio \
    --timer normal 180 'xrandr --output "$PRIMARY_DISPLAY" --brightness .1' 'xrandr --output "$PRIMARY_DISPLAY" --brightness 1' \
    --timer primary 10 'xrandr --output "$PRIMARY_DISPLAY" --brightness 1; physlock -d' '' \
    --timer normal 600 'systemctl suspend' ''

