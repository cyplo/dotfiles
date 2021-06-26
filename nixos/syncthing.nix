{ config, pkgs, inputs, ... }:
{
  services.syncthing = {
    enable = true;
    user = "cyryl";
    dataDir = "/home/cyryl/.syncthing";
    openDefaultPorts = true;
    package = inputs.nixpkgs-nixos-unstable.legacyPackages."x86_64-linux".syncthing;
  };
}
