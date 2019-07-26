#!/usr/bin/env bash

set -e
set -o pipefail

export PRIMARY_DISPLAY="$(xrandr | awk '/ primary/{print $1}')"

xset s off
xset -dpms
xidlehook \
    --not-when-fullscreen \
    --not-when-audio \
    --timer normal 180 'xrandr --output "$PRIMARY_DISPLAY" --brightness .1' 'xrandr --output "$PRIMARY_DISPLAY" --brightness 1' \
    --timer normal 600 'systemctl suspend' ''

