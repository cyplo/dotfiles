{
  permittedInsecurePackages = [
    "webkitgtk-2.4.11"
  ];
  allowUnfree = true;
  packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
}

