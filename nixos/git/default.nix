{ config, pkgs, lib, ... }:
{
  home-manager.users.cyryl = {...}: {
    imports = [
      ./home.nix
    ];
  };
}
