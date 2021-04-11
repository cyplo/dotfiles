My dotfiles - including my vim, terminal and font configs.
Mostly focusing on setting things up on NixOS, but supporting other OSes where possible.

## bootstrap new machine with NixOS:

1. boot the target machine from the livecd
1. change password for the default user `nixos`
1. ssh from another, already bootstrapped, machine

```bash
sudo su -
# `efibootmgr -b 000x -B` if you want to remove entry number x
yes | parted /dev/sda -- mklabel gpt
parted /dev/sda -- rm 1
parted /dev/sda -- rm 2
parted /dev/sda -- rm 3
parted /dev/sda -- rm 4
parted /dev/sda -- mkpart ESP fat32 1MiB 1GiB
parted /dev/sda -- set 1 esp on
parted /dev/sda -- mkpart primary 1GiB 100%
cryptsetup luksFormat /dev/sda2
```

```bash
cryptsetup luksOpen /dev/sda2 crypt
```

```bash
mkfs.fat -F 32 -n boot /dev/sda1
mkfs.btrfs -L nixos /dev/mapper/crypt
sleep 1
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
nixos-generate-config --root /mnt
nixos-install
```

## guix

I'm just starting to play with guix, these are just loose notes:
