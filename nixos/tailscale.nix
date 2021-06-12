{ config, pkgs, inputs, ... }:
let
  tailscale =  inputs.nixpkgs-nixos-unstable.legacyPackages."x86_64-linux".tailscale;

in {
  environment.systemPackages = [ tailscale ];
  services.tailscale = {
    enable = true;
    package = tailscale;
  };

  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };
}
