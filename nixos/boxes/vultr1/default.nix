{ config, pkgs, inputs, lib, ... }:
{
  networking.hostName = "vultr1";

  imports = [
    ./vultr-boot.nix
    ../../server-security.nix
    ../../tailscale.nix
    ./tailscale-vultr1.nix
    ../cli.nix
    ./nginx.nix
    ./folding.nix
    ./matrix-front.nix
  ];

  systemd.extraConfig = ''
    DefaultTimeoutStartSec=900s
  '';

  security.allowUserNamespaces = true;
  time.timeZone = "Europe/London";

}
