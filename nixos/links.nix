{ config, pkgs, ... }:

{
  home.file.".config/nixpkgs/config.nix".source = ~/dev/dotfiles/nixos/shell-config.nix;
}
