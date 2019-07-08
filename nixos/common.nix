{ config, pkgs, lib , ... }:

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
        wget git zsh gnupg curl tmux python36Packages.glances vim htop atop firefox home-manager
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


      virtualisation.docker = {
        enable = true;
        autoPrune.enable = true;
      };

      services = {
        fwupd.enable = true;
        tlp.enable = true;
        fstrim.enable = true;

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

        gnome3 = {
          chrome-gnome-shell.enable = true;
          gnome-keyring.enable = true;
        };
        xserver = {
          enable = true;
          layout = "pl";
          libinput = {
            enable = true;
            naturalScrolling = false;
            clickMethod = "clickfinger";
          };

          desktopManager = {
            gnome3 = {
              enable = true;
            };
          };
          displayManager.gdm= {
            enable = true;
            wayland = false;
          };
        };
      };

      security.pam.services.gdm.enableGnomeKeyring = true;

      fonts.fonts = [ pkgs.powerline-fonts ];

      sound.enable = true;
      networking.networkmanager.enable = true;
      hardware.enableRedistributableFirmware = true;
      hardware.cpu.intel.updateMicrocode = true;
      hardware.pulseaudio.enable = true;
      hardware.u2f.enable = true;
      hardware.brightnessctl.enable = true;
      hardware.sane.enable = true;
      powerManagement.cpuFreqGovernor = (lib.mkForce null);

      nix.gc.automatic = true;
      system.autoUpgrade.enable = true;
      system.stateVersion = "19.03";
    }

