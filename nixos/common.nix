{ config, pkgs, lib, ... }:
{
  imports =
    [
      ./common-hardware.nix
      ./common-services.nix
      ./security.nix
      ./syncthing.nix
    ];

    security.allowUserNamespaces = true;

    environment.enableDebugInfo = true;

    nixpkgs.config.allowUnfree = true;
    environment.systemPackages = with pkgs; [
      wget git gnupg curl tmux htop atop home-manager pciutils powertop fd dnsutils usbutils veracrypt
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
