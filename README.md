My dotfiles - including my vim, terminal and font configs.
Mostly focusing on setting things up on NixOS, but supporting other OSes where possible.

## bootstrap new machine with NixOS:

1. boot the target machine from the livecd
2. change password for the default user `nixos`
3. ssh from another, already bootstrapped, machine

remote (sata):

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

remote (nvme):
```bash
sudo su -
# `efibootmgr -b 000x -B` if you want to remove entry number x
yes | parted /dev/nvme0n1 -- mklabel gpt
parted /dev/nvme0n1 -- rm 1
parted /dev/nvme0n1 -- rm 2
parted /dev/nvme0n1 -- rm 3
parted /dev/nvme0n1 -- rm 4
parted /dev/nvme0n1 -- mkpart ESP fat32 1MiB 1GiB
parted /dev/nvme0n1 -- set 1 esp on
parted /dev/nvme0n1 -- mkpart primary 1GiB 100%
cryptsetup luksFormat /dev/nvme0n1p2

```
remote (sata):

```bash
cryptsetup luksOpen /dev/sda2 crypt
```

remote (nvme):

```bash
cryptsetup luksOpen /dev/nvme0n1p2 crypt
```

remote (sata):

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

remote (nvme):

```bash
mkfs.fat -F 32 -n boot /dev/nvme0n1p1
mkfs.btrfs -L nixos /dev/mapper/crypt
sleep 1
mount /dev/mapper/crypt /mnt
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
cp /mnt/etc/nixos/hardware-configuration.nix /mnt/home/cyryl/dev/dotfiles/nixos/boxes/hostname/
nix-shell -p nixUnstable git
nixos-install --flake '.#hostname-bootstrap'
reboot
```

ctrl-alt-f1 root login:

```bash
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

### Good Links [tm]
* https://nixpk.gs/pr-tracker.html
* https://pr-tracker.nevarro.space/

### inspiration
* start with flakes - https://github.com/mjlbach/nix-dotfiles/blob/4777ae6cf1a2bf88f5320a300e05bbe7ada57df8/nixos/flake.nix#L1-L10
* flakes - https://github.com/MatthewCroughan/nixcfg/blob/master/flake.nix#L45 for T480
* https://github.com/cole-mickens/nixcfg/tree/main
* https://git.sr.ht/~afontaine/nix/tree/main/item/andrew/mail/default.nix#L125-129 - proton mail bridge
* https://github.com/expipiplus1/dotfiles/blob/3d6ca2c8bcba3181bfe7bf16d331baf407c7a9dd/tests/home-test.nix - testing on CI
* https://git.knightsofthelambdacalcul.us/hazel/etc

### things to check out
* https://github.com/ryantm/agenix
* `nix-top`
* naersk for genpass
* https://github.com/divnix/devos
* https://github.com/tazjin/nix-1p
* https://github.com/nix-community/neovim-nightly-overlay
* install ISO - https://christine.website/blog/my-homelab-2021-06-08

### flakes

```
inputs = {
nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
};

outputs = { self, nixpkgs, ... }@inputs: {
nixosConfigurations = {
hyacinth = nixpkgs.lib.nixosSystem {
system = "x86_64-linux";
modules = [
(import ./machines/hyacinth)
];
specialArgs = { inherit inputs; };
};
```

## guix

I'm just starting to play with guix, these are just loose notes:
