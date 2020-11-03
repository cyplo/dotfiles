{ config, pkgs, ... }:

let
  unstableTarball = fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixpkgs-unstable.tar.gz;
in
  {
    imports =
      [
        ./syncthing.nix
        ./gsconnect.nix
        ./common-hardware.nix
        ./common-services.nix
        ./security.nix
      ];

      security.allowUserNamespaces = true;

      nixpkgs.config = {
        allowUnfree = true;
        packageOverrides = pkgs: {
          unstable = import unstableTarball {
            config = config.nixpkgs.config;
          };
        };
      };

      environment.enableDebugInfo = true;
      environment.systemPackages = with pkgs; [
        wget git gnupg curl tmux htop atop home-manager pciutils powertop fd dnsutils
      ];

      i18n.defaultLocale = "en_GB.UTF-8";

      users.users.cyryl = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" "video" "scanner" "lp" "docker" "vboxusers" "adbusers" "libvirtd" "dialout" ];
        shell = pkgs.zsh;
      };

      networking.hosts = {
      };

      programs.light.enable = true;
      programs.adb.enable = true;

      virtualisation.docker = {
        enable = true;
        autoPrune.enable = true;
      };

      fonts.fonts = with pkgs; [ powerline-fonts weather-icons material-icons source-code-pro fira-code noto-fonts-emoji emojione iosevka font-awesome nerdfonts ];

      services.haveged.enable = true;

      nix = {
        autoOptimiseStore = true;
        daemonIONiceLevel = 7;
        daemonNiceLevel = 19;
        gc.automatic = true;
        optimise.automatic = true;
      };

      system = {
        stateVersion = "20.03";
      };
    }
