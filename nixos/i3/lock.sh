#!/usr/bin/env bash

set -e
set -o pipefail

export PRIMARY_DISPLAY="$(xrandr | awk '/ primary/{print $1}')"

xset s off
xset -dpms

xidlehook \
    --not-when-fullscreen \
    --not-when-audio \
    --timer 60 \
    'xrandr --output "$PRIMARY_DISPLAY" --brightness .1' \
    'xrandr --output "$PRIMARY_DISPLAY" --brightness 1' \
    --timer 10 \
    'xrandr --output "$PRIMARY_DISPLAY" --brightness 1; physlock -d' \
    '' \
    --timer 600 \
    'xrandr --output "$PRIMARY_DISPLAY" --brightness 1; systemctl suspend' \
    ''
