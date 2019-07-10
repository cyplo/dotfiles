
{ config, pkgs, lib, ... }:
{
  time.timeZone = "Europe/London";

  services.xserver.desktopManager.plasma5.enable = lib.mkForce false;
  services.xserver.displayManager.sddm.enable = lib.mkForce false;

  virtualisation.virtualbox.guest.enable = true;
  virtualisation.virtualbox.guest.x11 = true;


  imports = [
    <nixpkgs/nixos/modules/installer/virtualbox-demo.nix>
    ../common.nix
  ];
}
