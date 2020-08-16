{ config, pkgs, ... }:
{
  networking.hostName = "skinnyv";

  imports = [
    <home-manager/nixos>
    /etc/nixos/hardware-configuration.nix
    ../../boot.nix
    ../../common.nix
    ../../gfx-intel.nix
    ../../zerotier.nix
    ../../i3
    ../../distributed-builds.nix
    ../../gui
    ../../git
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.luks.devices = {
      root =
        {
          device = "/dev/disk/by-uuid/ef6e91d9-c477-4ab7-ae39-4a0ee413cebe";
          preLVM = true;
          allowDiscards = true;
        };
      };
      loader.grub = {
        device = "nodev";
        efiSupport = true;
      };
      loader.efi.canTouchEfiVariables = true;
    };
    time.timeZone = "Europe/London";

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

      home.file.".config/i3/status.toml".source = ../../../.config/i3/status-single-bat.toml;
    };

  }
