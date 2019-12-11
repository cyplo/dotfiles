{ config, pkgs, ... }:

{
  home.file.".vimrc".source = ~/dev/dotfiles/.vimrc.nixos;
  home.file.".config/nixpkgs/config.nix".source = ~/dev/dotfiles/nixos/shell-config.nix;
}
