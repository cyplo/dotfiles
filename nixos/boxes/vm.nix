
{ config, pkgs, lib, ... }:
{
  time.timeZone = "Europe/London";

  services.xserver.desktopManager.plasma5.enable = lib.mkForce false;
  services.xserver.displayManager.sddm.enable = lib.mkForce false;

  imports = [ 
    <nixpkgs/nixos/modules/installer/virtualbox-demo.nix>
    ../common.nix
  ];
}
