{ config, pkgs, ... }:
{
  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = true;
    enableHardening = true;
    package = pkgs.unstable.virtualbox.override { enable32bitGuests = false; };
  };
}
