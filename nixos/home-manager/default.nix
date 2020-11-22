{ config, pkgs, ... }:

{
  home.sessionVariables = {
    LC_ALL="en_GB.UTF-8";
    LANG="en_GB.UTF-8";
    PASSWORD_STORE_ENABLE_EXTENSIONS="true";
  };

  news.display = "show";

  home.packages = with pkgs; [
    nerdfonts
    glibcLocales
  ];

  services.gpg-agent= {
    enable = true;
    pinentryFlavor = "curses";
  };

  services.kbfs.enable = true;

  imports = [
    ./programs/tmux.nix
    ./programs/zsh.nix
    ./programs/vim.nix
    ./programs/kitty.nix
    ./programs/newsboat.nix
    ./programs.nix
    ./links.nix
    ./cli.nix
  ];

}
