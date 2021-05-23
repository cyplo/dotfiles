{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    libqmi
  ];
  boot.extraModulePackages = with pkgs; [ libqmi ];
  boot.kernelModules = [ "qmi_wwan" "qcserial" ];
}
