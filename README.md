Please see https://git.cyplo.dev/cyplo/dotfiles for the actual sources.

My dotfiles - including my vim, terminal and font config.
My current setup consists of multiple machines running NixOS.
This is using flakes for reproducibility and home manager for setting up user-specific things.

Workstations are set up by running ` sudo nixos-rebuild switch --flake '.#'` and servers are by `nixos-rebuild switch --flake '.#servername' --target-host root@hostname`.
I don't use home manager the program, everything is referenced from the top flake.
