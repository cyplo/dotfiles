{ config, pkgs, ... }:

let
  unstableTarball = fetchTarball https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz;
  bisqTarball = fetchTarball https://github.com/emmanuelrosa/nixpkgs/archive/6ee154d2bc8c4c48cde2d7ae5bcd0a3da28b2b72.tar.gz;
  nurTarball = fetchTarball https://github.com/nix-community/NUR/archive/master.tar.gz;
in
  {
    imports =
      [
        ./syncthing.nix
        ./gsconnect.nix
        ./common-hardware.nix
        ./common-services.nix
        ./security.nix
        ./wireguard.nix
      ];

      security.allowUserNamespaces = true;

      nixpkgs.config = {
        allowUnfree = true;
        packageOverrides = pkgs: {
          unstable = import unstableTarball {
            config = config.nixpkgs.config;
          };
          bisq = import bisqTarball {
            config = config.nixpkgs.config;
          };
          nur = import nurTarball {
            inherit pkgs;
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
        extraGroups = [ "wheel" "networkmanager" "video" "scanner" "lp" "docker" "vboxusers" "adbusers" "libvirtd" "dialout" "wireshark" ];
        shell = pkgs.zsh;
      };

      networking.hosts = {
        "10.11.99.1" = [ "remarkable" ];
      };

      programs.light.enable = true;
      programs.adb.enable = true;
      programs.wireshark.enable=true;

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
        nixPath = [
          "nixpkgs=https://github.com/NixOS/nixpkgs/archive/20.09.tar.gz"
          "nixos-config=/etc/nixos/configuration.nix"
          "/nix/var/nix/profiles/per-user/root/channels"
          "home-manager=https://github.com/rycee/home-manager/archive/release-20.09.tar.gz"
        ];
        package = pkgs.nixUnstable;
        extraOptions = ''
          experimental-features = nix-command flakes
        '';
      };


      system = {
        stateVersion = "20.03";
      };
    }
