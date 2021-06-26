{ config, pkgs, inputs, ... }:
{
  networking.hostName = "foureighty";

  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
    ./hardware-configuration.nix
    ../../boot.nix
    ../../common.nix
    ../../gfx-intel.nix
    ../../tailscale.nix
    ./tailscale-foureighty.nix
    ../../distributed-builds.nix
    ../../libvirt.nix
    ../../backups.nix
    ../../gui
    ../../i3
    ../../git
    ../../mercurial
  ];

  fileSystems."/" = {
    options = [ "compress=zstd" ];
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 75;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest_hardened;
  time.timeZone = "Europe/London";

  hardware.trackpoint.enable = true;
  services.hardware.bolt.enable = true;
  services.fprintd = {
    enable = true;
  };

  fonts.fontconfig.enable = true;
  programs.steam.enable = true;

  home-manager.users.cyryl = {...}: {
    home.packages = [ inputs.bisq.legacyPackages."x86_64-linux".bisq-desktop ];
  };
}
