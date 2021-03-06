{ config, pkgs, inputs, lib, ... }:
{
  imports = [
    ./brix-boot.nix
    ./real-hardware.nix
    ../../server-security.nix
    ../cli.nix
    ../../tailscale.nix
    ./tailscale-brix.nix
    ./restic-server.nix
    ./i2p.nix
    ./print-server.nix
    ./matrix-server.nix
  ];
  networking = {
    hostName = "brix";
    useDHCP = false;
    interfaces.enp3s0.useDHCP = true;
  };
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  security.allowUserNamespaces = true;

  time.timeZone = "Europe/London";

}
