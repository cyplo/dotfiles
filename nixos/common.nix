{ config, pkgs, ... }:

let
  unstableTarball = fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz;
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
        };
      };

      environment.systemPackages = with pkgs; [
        wget git gnupg curl tmux python36Packages.glances htop atop firefox home-manager alacritty pciutils powertop ripgrep-all fd dnsutils
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
        stateVersion = "19.09";
      };
    }
