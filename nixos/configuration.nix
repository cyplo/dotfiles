{ config, pkgs, ... }:

let
  unstableTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz;
in
{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
    ];

  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    wget vim git zsh gnupg curl tmux microcodeIntel
  ];

  networking.hostName = "skinnyv";

  users.users.cyryl = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
      packages = with pkgs; [
       firefox chromium terminator zsh keepass fontconfig go nodejs unstable.rustup gcc gdb binutils xclip pkgconfig veracrypt gitAndTools.diff-so-fancy gnome3.gnome-shell-extensions chrome-gnome-shell gnomeExtensions.clipboard-indicator gnomeExtensions.caffeine gnomeExtensions.no-title-bar unstable.gnomeExtensions.gsconnect unstable.appimage-run openjdk10 
      ];
    uid = 1000;
    shell = pkgs.zsh;
  };

  services = {
    gnome3.chrome-gnome-shell.enable = true;

    fwupd.enable = true;

    syncthing = {
      enable = true;
      user = "cyryl";
      dataDir = "/home/cyryl/.syncthing";
      openDefaultPorts = true;
    };

    xserver = {
      enable = true;
      layout = "pl";
      libinput.enable = true;

      desktopManager = {
        gnome3.enable = true;
        xterm.enable = false;
      };
      displayManager.gdm.enable = true;
    };
  };

  time.timeZone = "Europe/London";

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  boot = {
    initrd.luks.devices = [
      {
        name = "root";
        device = "/dev/disk/by-uuid/8c76bf01-59b3-4c60-b853-e9cb77f3ca14";
        preLVM = true;
        allowDiscards = true;
      }
    ];
    loader.grub = {
      enable = true;
      version = 2;
      device = "nodev";
      efiSupport = true;
    };
    loader.efi.canTouchEfiVariables = true;
  };

  system.stateVersion = "18.09";
}

