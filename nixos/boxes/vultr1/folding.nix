{ config, pkgs, lib, ... }:
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "fahclient"
  ];
  services.foldingathome = {
    enable = true;
    user = "cyplo";
  };
  boot.kernel.sysctl = {
    "kernel.unprivileged_userns_clone" = 1;
  };
}
