{ config, pkgs, ... }:
{
  networking.hostName = "foureighty";

  imports = [
    <home-manager/nixos>
    ./hardware-configuration.nix
    ../../boot.nix
    ../../common.nix
    ../../gfx-intel.nix
    ../../zerotier.nix
    ../../distributed-builds.nix
    ../../libvirt.nix
    ../../backups.nix
    ../../gui
    ../../i3
    ../../git
    ../../mercurial
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  time.hardwareClockInLocalTime = true;
  time.timeZone = "Europe/London";

  hardware.trackpoint.enable = true;
  services.hardware.bolt.enable = true;
  services.fprintd = {
    enable = true;
  };

  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "nixos-config=/etc/nixos/configuration.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
    "home-manager=https://github.com/rycee/home-manager/archive/master.tar.gz"
  ];

  fonts.fontconfig.enable = true;
  home-manager.users.cyryl = {...}: {
    imports = [
      ../../home-manager
    ];
    home.stateVersion = config.system.stateVersion;

    nixpkgs.overlays = config.nixpkgs.overlays;
    nixpkgs.config = config.nixpkgs.config;

    home.file.".config/i3/status.toml".source = ../../../.config/i3/status-double-bat.toml;
  };

}
