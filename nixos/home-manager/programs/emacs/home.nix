{ config, pkgs, ... }:
{
  programs.emacs = {
    enable = true;
    package = (import ./emacs.nix { inherit pkgs; });
  };

}
