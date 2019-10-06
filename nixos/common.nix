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
        ./common-services.nix
        ./vim.nix
        ./cachix.nix
      ];

      nixpkgs.config = {
        allowUnfree = true;
        packageOverrides = pkgs: {
          unstable = import unstableTarball {
            config = config.nixpkgs.config;
          };
          cyplo = import /home/cyryl/dev/nixpkgs {
            config = config.nixpkgs.config;
          };
        };
      };

      environment.systemPackages = with pkgs; [
        wget git gnupg curl tmux python36Packages.glances htop atop firefox home-manager alacritty pciutils powertop

      ];

      i18n.defaultLocale = "en_GB.UTF-8";

      users.users.cyryl = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" "video" "scanner" "lp" "docker" "vboxusers" "adbusers" ];
        shell = pkgs.zsh;
      };

      programs.light.enable = true;
      programs.adb.enable = true;

      virtualisation.docker = {
        enable = true;
        autoPrune.enable = true;
      };

      fonts.fonts = with pkgs; [ powerline-fonts weather-icons material-icons source-code-pro fira-code noto-fonts-emoji emojione iosevka ];

      nix = {
        autoOptimiseStore = true;
        daemonIONiceLevel = 7;
        daemonNiceLevel = 19;
        gc.automatic = true;
        optimise.automatic = true;
      };

      system = {
        autoUpgrade.enable = true;
        stateVersion = "19.03";
      };
    }
