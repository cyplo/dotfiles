{ config, pkgs, ... }:
{
  services.foldingathome = {
    enable = true;
    user = "cyplo";
  };
  boot.kernel.sysctl = {
    "kernel.unprivileged_userns_clone" = 1;
  };
}
