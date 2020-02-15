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

    fzf.enable = true;
    chromium.enable = true;
    go.enable = true;
    bat.enable = true;
    browserpass.enable = true;
  };
}
