My dotfiles - including my vim, terminal and font configs.
Mostly focusing on setting things up on NixOS, but supporting other OSes where possible.

bootstrap new machine with NixOS:

1. boot the target machine from the livecd
1. change password for the default user `nixos`
1. ssh from another, already bootstrapped, machine
1. `sudo su -`
1. `yes | parted /dev/sda -- mklabel gpt`
1. [ ] LUKS !
1. `parted /dev/sda -- mkpart ESP fat32 1MiB 1GiB`
1. `parted /dev/sda -- set 1 esp on`
1. `parted /dev/sda -- mkpart primary btrfs 1GiB -8193MiB`
1. http://opensource.hqcodeshop.com/Parted%20calculator/parted_mkpart_calc.sh
1. `parted /dev/sda -- mkpart primary linux-swap XXX 100%`
1. `mkfs.fat -F 32 -n boot /dev/sda1`
1. `mkfs.btrfs -L nixos /dev/sda2`
1. `mkswap -L swap /dev/sda3`
1. `mount /dev/disk/by-label/nixos /mnt`
1. `mkdir -p /mnt/boot`
1. `mount /dev/disk/by-label/boot /mnt/boot`
1. `swapon /dev/sda3`
1. `nixos-generate-config --root /mnt`
1. `vim /mnt/etc/nixos/configuration.nix`
