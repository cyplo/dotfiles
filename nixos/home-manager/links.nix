{ config, pkgs, ... }:

{
  home.file.".config/nixpkgs/config.nix".source = ../shell-config.nix;
  home.file.".gdbinit".text = ''
    set auto-load python-scripts on
    add-auto-load-safe-path /home/cyryl/dev/dotfiles/.gdbinit
    source /home/cyryl/dev/dotfiles/.gdbinit
  '';
}
