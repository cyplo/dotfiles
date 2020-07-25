{ config, pkgs, ... }:
{
  networking.hostName = "skinnyv";

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

    fonts.fontconfig.enable = true;
    home-manager.users.cyryl = {...}: {
      imports = [
        ./home.nix
      ];
      home.stateVersion = config.system.stateVersion;

      nixpkgs.overlays = config.nixpkgs.overlays;
      nixpkgs.config = config.nixpkgs.config;
    };

    imports = [
      <home-manager/nixos>
      /etc/nixos/hardware-configuration.nix
      ../../boot.nix
      ../../common.nix
      ../../gfx-intel.nix
      ../../zerotier.nix
      ../../i3/system.nix
      ../../distributed-builds.nix
    ];
  }
