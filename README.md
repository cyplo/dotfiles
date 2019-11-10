My dotfiles - including my vim, terminal and font configs.
Mostly focusing on setting things up on NixOS, but supporting other OSes where posible.

bootstrap new machine with NixOS:

1. Launch `curl https://raw.githubusercontent.com/cyplo/dotfiles/master/nixos/bootstrap-livecd.sh | bash` from NixOS live cd.

2. Reboot into the system running from the disk drive.

3. Launch `curl https://raw.githubusercontent.com/cyplo/dotfiles/master/nixos/bootstrap-rebooted.sh | bash` from the installed system.
