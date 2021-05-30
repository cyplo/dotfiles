{ pkgs }:
let
  myEmacs = pkgs.emacs-nox;
  emacsWithPackages = (pkgs.emacsPackagesGen myEmacs).emacsWithPackages;
in
  emacsWithPackages (epkgs: (with epkgs.melpaStablePackages; [
    magit
    solarized-theme
    evil
  ])
  ++ (with epkgs.melpaPackages; [
    xterm-color
    nix-mode
  ])
  ++ (with epkgs.elpaPackages; [
    beacon         # ; highlight my cursor when scrolling
    nameless       # ; hide current package name everywhere in elisp code
  ]) ++ [
    pkgs.notmuch   # From main packages set
  ])
