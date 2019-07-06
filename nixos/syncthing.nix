{ config, pkgs, ... }:
let
  unstableTarball = fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz;
in
{
    nixpkgs.config = {
      packageOverrides = pkgs: {
        unstable = import unstableTarball {
          config = config.nixpkgs.config;
        };
      };
    };
    services.syncthing = {
        enable = true;
        user = "cyryl";
        dataDir = "/home/cyryl/.syncthing";
        openDefaultPorts = true;
        package = pkgs.unstable.syncthing;
    };
}
