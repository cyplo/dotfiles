My dotfiles - including my vim, terminal and font configs.
Mostly focusing on setting things up on NixOS, but supporting other OSes where possible.

## bootstrap new machine with NixOS:

1. boot the target machine from the livecd
2. change password for the default user `nixos`
3. ssh from another, already bootstrapped, machine

remote:

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

remote:

```bash
cryptsetup luksOpen /dev/sda2 crypt
```

remote:

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

local:

```bash
tar -cvz . > ../dotfiles.tar.gz
scp ../dotfiles.tar.gz nixos@remote:/tmp
```

remote:

```bash
mkdir -p /mnt/home/cyryl/dev/dotfiles/
tar -xvf /tmp/dotfiles.tar.gz -C /mnt/home/cyryl/dev/dotfiles
cp /mnt/etc/nixos/hardware-configuration.nix /mnt/home/cyryl/dev/dotfiles/nixos/boxes/bootstrap/
ln -vfs /mnt/home/cyryl/dev/dotfiles/nixos/boxes/bootstrap/1.nix /mnt/etc/nixos/configuration.nix
nixos-install
reboot
```

ctrl-alt-f1 root login:

```bash
ln -vfs /home/cyryl/dev/dotfiles/nixos/boxes/bootstrap/2.nix /etc/nixos/configuration.nix
vim /home/cyryl/dev/dotfiles/nixos/boxes/bootstrap/2.nix
nixos-rebuild switch
passwd cyryl
chown cyryl -R /home/cyryl
reboot
```

gui-login as cyryl:

```bash
cd ~/dev/dotfiles/
mkdir -p nixos/boxes/HOSTNAME
cp nixos/boxes/bootstrap/2.nix nixos/boxes/HOSTNAME/default.nix
cp nixos/boxes/bootstrap/hardware-configuration.nix nixos/boxes/HOSTNAME/
sudo ln -vfs /home/cyryl/dev/dotfiles/nixos/boxes/HOSTNAME/default.nix /etc/nixos/configuration.nix
sudo nixos-rebuild switch --upgrade
reboot
```

```bash
ssh-keygen -t ed25519
# syncthing
# vault
# firefox sync
# bitwarden
# add key to sr.ht
cd ~/dev/dotfiles
git remote add git@git.sr.ht:~cyplo/dotfiles
git checkout nixos/boxes/bootstrap
```

## guix

I'm just starting to play with guix, these are just loose notes:
