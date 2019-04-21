{ config, pkgs, ... }:

let
  unstableTarball = fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz;
in
{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ./vscode.nix
      ./syncthing.nix
      ./gsconnect.nix
      ./gfx.nix
      ./boot.nix

      ./boxes/skinnyv.nix # TODO: invert relationship
    ];

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
      cyplo = import "/home/cyryl/dev/nixpkgs/" {
        config = config.nixpkgs.config;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    wget git zsh gnupg curl tmux python36Packages.glances
  ];

  i18n.defaultLocale = "en_GB.UTF-8";

  users.users.cyryl = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "scanner" "lp" "docker" "vboxusers"];
      packages = with pkgs; [
        firefox chromium alacritty zsh keepass fontconfig go nodejs rustup gcc gdb
        binutils xclip pkgconfig veracrypt gitAndTools.diff-so-fancy
        gnome3.gnome-shell-extensions chrome-gnome-shell gnomeExtensions.clipboard-indicator
        gnomeExtensions.caffeine gnomeExtensions.no-title-bar
        openjdk11 gimp restic glxinfo discord steam
        zoom-us
        nodejs-10_x hugo mercurial terraform libreoffice
        unzip tor-browser-bundle-bin aria vlc
        jetbrains.goland jetbrains.clion
        (wine.override { wineBuild = "wineWow"; })
        yubico-piv-tool yubikey-personalization yubikey-personalization-gui yubikey-manager-qt
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
    fwupd.enable = true;

    printing = {
      enable = true;
      drivers = [ pkgs.epson-escpr ];
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

    gnome3.chrome-gnome-shell.enable = true;
    gnome3.gnome-keyring.enable = true;
    xserver = {
      enable = true;
      layout = "pl";
      libinput.enable = true;

      desktopManager = {
        gnome3.enable = true;
      };
      displayManager.gdm= {
        enable = true;
        wayland = false;
      };
    };
  };

  security.pam.services.gdm.enableGnomeKeyring = true;

  time.timeZone = "Europe/London";

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.u2f.enable = true;
  hardware.brightnessctl.enable = true;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.sane.enable = true;

  nix.gc.automatic = true;
  system.autoUpgrade.enable = true;
  system.stateVersion = "18.09";
}

