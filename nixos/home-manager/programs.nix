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

    gpg = {
      enable = true;
      settings = {
      };
    };
    taskwarrior.enable = true;
    fzf.enable = true;
    chromium.enable = true;
    go.enable = true;
    bat.enable = true;
    browserpass.enable = true;
    obs-studio.enable = true;
    lsd.enable = true;
    lsd.enableAliases = true;
  };
}
