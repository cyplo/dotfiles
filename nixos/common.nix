{ config, pkgs, ... }:

let
  unstableTarball = fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz;
  etesync-dav = import ./packages/etesync-dav/default.nix;
in
  {
    imports =
      [
        ./vscode.nix
        ./syncthing.nix
        ./gsconnect.nix
        ./common-hardware.nix
      ];

      nixpkgs.config = {
        allowUnfree = true;
        packageOverrides = pkgs: {
          unstable = import unstableTarball {
            config = config.nixpkgs.config;
          };
          cyplo = import ./nixpkgs {
            config = config.nixpkgs.config;
          };
        };
      };

      environment.systemPackages = with pkgs; [
        wget git gnupg curl tmux python36Packages.glances vim htop atop firefox home-manager alacritty pciutils
      ];

      i18n.defaultLocale = "en_GB.UTF-8";

      users.users.cyryl = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" "video" "scanner" "lp" "docker" "vboxusers"];
        packages = with pkgs; [
          unstable.pypi2nix etesync-dav unstable.hopper
        ];
        shell = pkgs.zsh;
      };

      programs.light.enable = true;

      virtualisation.docker = {
        enable = true;
        autoPrune.enable = true;
      };

      services = {
        fwupd.enable = true;
        tlp.enable = true;
        fstrim.enable = true;
        clipmenu.enable = true;

        physlock = {
          enable = true;
          allowAnyUser = true;
        };

        printing = {
          enable = true;
          drivers = [ pkgs.epson-escpr pkgs.samsung-unified-linux-driver pkgs.splix ];
        };

        avahi = {
          enable = true;
          nssmdns = true;
        };

        restic.backups.home = {
          passwordFile = "/etc/nixos/secrets/restic-password";
          paths = [ "/home" ];
          repository = "sftp:fetcher@brix:/mnt/data/backup-targets";
          timerConfig = { OnCalendar = "hourly"; };
        };

        xserver = {
          enable = true;
          layout = "pl";
          libinput = {
            enable = true;
            naturalScrolling = false;
            clickMethod = "clickfinger";
          };

          displayManager.sddm = {
            enable = true;
            enableHidpi = true;
          };
        };
      };

      fonts.fonts = [ pkgs.powerline-fonts ];

      nix.gc.automatic = true;
      nix.autoOptimiseStore = true;
      nix.optimise.automatic = true;
      nix.daemonIONiceLevel = 7;
      nix.daemonNiceLevel = 19;
      system.autoUpgrade.enable = true;
      system.stateVersion = "19.03";
    }
