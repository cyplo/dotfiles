{ config, pkgs, ... }:
{
  powerManagement.cpuFreqGovernor = "ondemand";
  boot.kernelPatches = [ {
    name = "foureighty";
    patch = null;
    extraConfig = ''
      WATCH_QUEUE y
      MCORE2 y
      ENERGY_MODEL y
      INTEL_TXT y
    '';
  } ];
}
