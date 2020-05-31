{ config, pkgs, ... }:
{
  boot.kernelModules = [ "kvm-intel" ];
  boot.kernelParams = [ "intel_iommu=on" ];
  virtualisation.libvirtd.enable = true;
  virtualisation.kvmgt.enable = true;

  environment.systemPackages = with pkgs; [
    virtmanager qemu
  ];

}
