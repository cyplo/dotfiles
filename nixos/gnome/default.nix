{ config, pkgs, ... }:
{
  imports = [
    ./system.nix
  ];

  home-manager.users.cyryl = {...}: {
    imports = [
      ./home.nix
    ];
  };
}
