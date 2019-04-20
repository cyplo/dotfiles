{ config, pkgs, ... }:

let
  unstableTarball = fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz;
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
      cyplo = import "/home/cyryl/dev/nixpkgs/" {
        config = config.nixpkgs.config;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    wget git zsh gnupg curl tmux python36Packages.glances
    gnomeExtensions.gsconnect
    (
      vim_configurable.override {
        python = python3;
      }
    )
  ];

  networking.hostName = "skinnyv";
  # gsconnect
  networking.firewall.allowedTCPPortRanges = [ { from = 1716; to = 1764; }  ];
  networking.firewall.allowedUDPPortRanges = [ { from = 1716; to = 1764; }  ];

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
        (unstable.vscode-with-extensions.override {
          vscodeExtensions = with vscode-extensions; [ bbenoist.Nix ms-python.python ]
          ++ vscode-utils.extensionsFromVscodeMarketplace [
          {
            publisher = "2gua";
            name = "rainbow-brackets";
            version = "0.0.6";
            sha256 = "1m5c7jjxphawh7dmbzmrwf60dz4swn8c31svbzb5nhaazqbnyl2d";
          }
          {
            publisher = "vscodevim";
            name = "vim";
            version = "1.4.0";
            sha256 = "0vfhvsp485rgik3pjzbpnc4jxrjpiykynl563a16rlz8h85x2m4f";
          }
          {
            publisher = "swyphcosmo";
            name = "spellchecker";
            version = "1.2.13";
            sha256 = "1lr33lf01afgi74c1a9gylk92li4hyq24l8bki4l6ggl4z4c2h3w";
          }
          {
            publisher = "asabil";
            name = "meson";
            version = "1.1.1";
            sha256 = "00cc28a2nb325f54bx51wf5q15x1pmsn0j9z6rnxxqxwii1dm5cl";
          }
          {
            publisher = "bungcip";
            name = "better-toml";
            version = "0.3.2";
            sha256 = "08lhzhrn6p0xwi0hcyp6lj9bvpfj87vr99klzsiy8ji7621dzql3";
          }
          {
            publisher = "codezombiech";
            name = "gitignore";
            version = "0.6.0";
            sha256 = "0gnc0691pwkd9s8ldqabmpfvj0236rw7bxvkf0bvmww32kv1ia0b";
          }
          {
            publisher = "DavidAnson";
            name = "vscode-markdownlint";
            version = "0.26.0";
            sha256 = "0g4pssvajn7d8p2547v7313gjyqx4pzs7cbjws2s3v2fk1sw7vbj";
          }
          {
            publisher = "esbenp";
            name = "prettier-vscode";
            version = "1.8.1";
            sha256 = "0qcm2784n9qc4p77my1kwqrswpji7bp895ay17yzs5g84cj010ln";
          }
          {
            publisher = "hbenl";
            name = "vscode-test-explorer";
            version = "2.9.3";
            sha256 = "1yf85hgvganxq5n5jff9ckn3smxd6xi79cgn6k53qi5w1r5rahy0";
          }
          {
            publisher = "hbenl";
            name = "vscode-test-explorer-liveshare";
            version = "1.0.4";
            sha256 = "0a57cm8bjfvz2whkr6krjv3whv9c7sdzlrjwdr5zaz78nxn9dfy7";
          }
          {
            publisher = "lextudio";
            name = "restructuredtext";
            version = "106.0.0";
            sha256 = "096r8071202nxi1is6z7dghcmpsh0f0mm3mp3cfh1yj2mnyzlaxa";
          }
          {
            publisher = "lostintangent";
            name = "vsls-pomodoro";
            version = "0.1.0";
            sha256 = "1b73zbkhlhacvi18cx4g3n6randy3hw9cab1gkw5gzb3375w7w3p";
          }
          {
            publisher = "lostintangent";
            name = "vsls-whiteboard";
            version = "0.0.8";
            sha256 = "13fcay9bs861msb5y694casbw66dmhl504xm5cvprssx1qka186p";
          }
          {
            publisher = "mauve";
            name = "terraform";
            version = "1.3.9";
            sha256 = "0hnarr21rivvv41y5x1sp0skdmzwz7zi9aya3n5z1b13ir7lyy42";
          }
          {
            publisher = "mechatroner";
            name = "rainbow-csv";
            version = "1.0.0";
            sha256 = "1fyamgm7zq31r3c00cn6pcb66rrkfhwfmp72qnhrajydmnvcnbg6";
          }
          {
            publisher = "ms-vscode";
            name = "Go";
            version = "0.9.2";
            sha256 = "0yxnsby8zz1dvnx8nqrhi4xx316mpjf2hs2c5r6fkzh8zhjccwqz";
          }
          {
            publisher = "ms-vsliveshare";
            name = "vsliveshare";
            version = "1.0.67";
            sha256 = "1shy9xaqz1wsyzzz5z8g409ma5h5kaic0y7bc1q2nxy60gbq828n";
          }
          {
            publisher = "ms-vsliveshare";
            name = "vsliveshare-audio";
            version = "0.1.48";
            sha256 = "1lccsyhj3mgbacw76hikgml85hi82zipaza1194nqnj1inhci80b";
          }
          {
            publisher = "PeterJausovec";
            name = "vscode-docker";
            version = "0.6.1";
            sha256 = "0clxy66qi5c3k5di5xsjm3vjib525xq89z1q2h3a5x5qwvbvd0mj";
          }
          {
            publisher = "ritwickdey";
            name = "LiveServer";
            version = "5.6.1";
            sha256 = "077arf3hsn1yb8xdhlrax5gf93ljww78irv4gm8ffmsqvcr1kws0";
          }
          {
            publisher = "ronnidc";
            name = "nunjucks";
            version = "0.2.3";
            sha256 = "119xgyn1dggw2rcqkn2mnz364iw5jlrxg7pcydbijsqj5d3zdfsf";
          }
          {
            publisher = "rust-lang";
            name = "rust";
            version = "0.6.1";
            sha256 = "0f66z6b374nvnrn7802dg0xz9f8wq6sjw3sb9ca533gn5jd7n297";
          }
          {
            publisher = "serayuzgur";
            name = "crates";
            version = "0.4.2";
            sha256 = "1knspsc98cfw4mhc0yaz0f2185sxdf9kn9qsysfs6c82g9wjaqcj";
          }
          ];})
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
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-media-driver
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

  nix.gc.automatic = true;
  system.autoUpgrade.enable = true;
  system.stateVersion = "18.09";
}

