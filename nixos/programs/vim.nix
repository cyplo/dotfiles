{ config, pkgs, ... }:
{
  programs.vim = {
    enable = true;
    extraConfig = builtins.readFile ~/dev/dotfiles/.vimrc.nixos;
    plugins = [
      "vim-gitgutter"
      "vim-toml"
      "vim-autoformat"
      "editorconfig-vim"
      "tabular"
      "vim-colors-solarized"
      "fzf-vim"
      "ctrlp-vim"
      "vim-nix"
      "vim-startify"
      "ack-vim"
      "vim-markdown"
      "rust-vim"
      "nerdtree"
      "vim-dispatch"
      "deoplete-nvim"
      "deoplete-go"
      "vim-fugitive"
      "vim-sensible"
      "vim-surround"
      "vim-airline"
      "vim-airline-themes"
      "vim-dirdiff"
      "nerdtree-git-plugin"
    ];
  };
}
