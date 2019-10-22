#!/bin/sh
profile="$HOME/.nix-profile/bin/"
system="/run/current-system/sw/bin/"

sensors="$profile/sensors"

max_temp=`$sensors | $system/egrep -o '[0-9][0-9]\.[0-9]' | $system/sort | $system/uniq | $system/tail -n 1`

echo "${max_temp}°C"
