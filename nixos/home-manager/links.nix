{ config, pkgs, ... }:

{
  home.file.".config/nixpkgs/config.nix".source = ../shell-config.nix;
  home.file.".gdbinit".text = ''
    set auto-load python-scripts on
    add-auto-load-safe-path /home/cyryl/dev/dotfiles/.gdbinit
    set auto-load safe-path /
    source /home/cyryl/dev/dotfiles/.gdbinit
  '';
  home.file.".gdbinit.d/dashboard".text = ''
    dashboard -layout breakpoints source expressions stack threads variables
    dashboard variables -style compact 0
    dashboard source -style height 24
    dashboard stack -style compact 1
    dashboard stack -style limit 3
  '';
}
