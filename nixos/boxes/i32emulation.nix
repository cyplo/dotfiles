{ config, pkgs, ... }:
{
  nixpkgs.config.packageOverrides = pkgs: {
    linux_latest_hardened = pkgs.linux_latest_hardened.override {
      extraConfig = ''
        IA32_EMULATION y
        KVM m
        KVM_INTEL m
      '';
      features.ia32Emulation = true;
      enableParallelBuilding = true;
    };
  };

  hardware.opengl.extraPackages32 = [ pkgs.linuxPackages.nvidia_x11.lib32 pkgs.pkgsi686Linux.libva ];
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;
}
