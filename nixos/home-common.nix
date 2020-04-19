{ config, pkgs, ... }:

{
  home.sessionVariables = {
    LC_ALL="en_GB.UTF-8";
    LANG="en_GB.UTF-8";
    TERMINAL="alacritty";
    CM_LAUNCHER="rofi";
    PASSWORD_STORE_ENABLE_EXTENSIONS="true";
  };

  news.display = "show";

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [ nerdfonts ];

  imports = [
    ./programs/tmux.nix
    ./programs/zsh.nix
    ./programs/vim.nix
    ./programs/alacritty.nix
    ./programs.nix
    ./links.nix
    ./cli.nix
    ./i3/home.nix
  ];

}
