#!/usr/bin/env bash

# needs to be launched from nixos livecd
if [[ `hostname` != "nixos" ]]; then
    echo "this script can only be ran from NixOS livecd"
    exit 1
fi

echo "Done. Please reboot now"

