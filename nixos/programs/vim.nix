{ config, pkgs, ... }:
{
  home.file.".vimrc".source = ~/dev/dotfiles/.vimrc.nixos;
  home.packages = with pkgs; [
    unstable.rust-analyzer
    nodejs
    (
      neovim.override {
        vimAlias = true;
        configure = {
          customRC = ''
            if filereadable($HOME . "/.vimrc")
              source $HOME/.vimrc
            endif
          '';

          vam.knownPlugins = vimPlugins;
          vam.pluginDictionaries = [
            { names = [
              "ack-vim"
              "coc-highlight"
              "coc-nvim"
              "coc-tabnine"
              "ctrlp-vim"
              "editorconfig-vim"
              "fzf-vim"
              "nerdtree"
              "nerdtree-git-plugin"
              "rust-vim"
              "tabular"
              "vim-airline"
              "vim-airline-themes"
              "vim-autoformat"
              "vim-colors-solarized"
              "vim-dirdiff"
              "vim-dispatch"
              "vim-fugitive"
              "vim-gitgutter"
              "vim-markdown"
              "vim-nix"
              "vim-sensible"
              "vim-startify"
              "vim-surround"
              "vim-toml"
            ];}];
          };})

        ];
      }
