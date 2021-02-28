{ config, pkgs, ... }:
{
  networking.hostName = "skinnyv";

  imports = [
    <home-manager/nixos>
    ./hardware-configuration.nix
    ../../boot.nix
    ../../common.nix
    ../../gfx-intel.nix
    ../../zerotier.nix
    ../../i3
    ../../distributed-builds.nix
    ../../gui
    ../../git
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest_hardened;
  time.timeZone = "Europe/London";

  fonts.fontconfig.enable = true;
  home-manager.users.cyryl = {...}: {
    imports = [
      ../../home-manager
    ];
    home.stateVersion = config.system.stateVersion;

    nixpkgs.overlays = config.nixpkgs.overlays;
    nixpkgs.config = config.nixpkgs.config;

    home.file.".config/i3/status.toml".source = ../../../.config/i3/status-single-bat.toml;
  };

}
