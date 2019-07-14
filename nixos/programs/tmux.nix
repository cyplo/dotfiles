{ config, pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    shortcut = "a";
    extraConfig = ''
          set -g status off
          set -g mouse on
    '';
  };
}
