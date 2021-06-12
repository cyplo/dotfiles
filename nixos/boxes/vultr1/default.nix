{ config, pkgs, inputs, lib, ... }:
{
  networking.hostName = "vultr1";

  imports = [
    ./vultr-boot.nix
    ../vpn.nix
    ../../server-security.nix
    ../cli.nix
    ./nginx.nix
    ./search.nix
    ./folding.nix
    ./matrix-front.nix
  ];

  systemd.extraConfig = ''
    DefaultTimeoutStartSec=900s
  '';

  security.allowUserNamespaces = true;
  time.timeZone = "Europe/London";

}
