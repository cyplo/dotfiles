{ config, pkgs, ... }:
{
  services.xserver.videoDrivers = [ "intel" ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    s3tcSupport = true;
    extraPackages = with pkgs; [
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-media-driver
    ];
  };

  nixpkgs.config = {
    packageOverrides = pkgs: {
      vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
    };
  };

}
