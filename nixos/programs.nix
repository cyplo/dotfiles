{ config, pkgs, ... }:

{
  programs = {
    home-manager.enable = true;

    z-lua = {
      enable = true;
      enableAliases = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    rofi.enable = true;
    fzf.enable = true;
    chromium.enable = true;
    go.enable = true;
    bat.enable = true;
  };
}
