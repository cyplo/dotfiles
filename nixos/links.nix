{ config, pkgs, ... }:

{
  home.file.".vimrc".source = ~/dev/dotfiles/.vimrc.nixos;
  home.file.".config/nixpkgs/config.nix".source = ~/dev/dotfiles/nixos/shell-config.nix;
  home.file.".mozilla/native-messaging-hosts/passff.json".source = "${pkgs.passff-host}/share/passff-host/passff.json";
}
