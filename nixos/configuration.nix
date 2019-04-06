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
    allowUnfree = true;
    packageOverrides = pkgs: {
      vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    wget git zsh gnupg curl tmux python36Packages.glances 
    (
      vim_configurable.override {
        python = python3;
      }
    )
  ];

  networking.hostName = "skinnyv";

  users.users.cyryl = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "scanner" "lp" "docker" "vboxusers"]; 
      packages = with pkgs; [
       firefox chromium terminator zsh keepass fontconfig go nodejs unstable.rustup gcc gdb binutils xclip pkgconfig veracrypt gitAndTools.diff-so-fancy gnome3.gnome-shell-extensions chrome-gnome-shell gnomeExtensions.clipboard-indicator gnomeExtensions.caffeine gnomeExtensions.no-title-bar unstable.gnomeExtensions.gsconnect unstable.appimage-run openjdk10 pdftk pdfshuffler gimp restic glxinfo
      ];
    uid = 1000;
    shell = pkgs.zsh;
  };

  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = true;
    enableHardening = false; #needed for 3D acceleration
  };

  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
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

    restic.backups.home = {
      passwordFile = "/etc/nixos/secrets/restic-password";
      paths = [ "/home" ];
      repository = "sftp:fetcher@brix:/mnt/data/backup-targets";
      timerConfig = { OnCalendar = "hourly"; };
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
  hardware.u2f.enable = true;
  hardware.brightnessctl.enable = true;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      unstable.intel-media-driver
    ];
  };
  hardware.sane.enable = true;

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
    kernelParams = [
      "i915.enable_rc6=7"
    ];
  };


  system.autoUpgrade.enable = true;
  system.stateVersion = "18.09";
}

