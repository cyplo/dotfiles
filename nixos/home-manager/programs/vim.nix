{ config, pkgs, ... }:
{
  home.file.".vimrc".source = ../../../.vimrc.nixos;
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

    plugins = with pkgs.vimPlugins; [
      ack-vim
      coc-highlight
      coc-nvim
      coc-rust-analyzer
      ctrlp-vim
      editorconfig-vim
      fzf-vim
      nerdtree
      nerdtree-git-plugin
      quickfix-reflector-vim
      rainbow
      tabular
      vim-airline
      vim-airline-themes
      vim-autoformat
      vim-colors-solarized
      vim-devicons
      vim-dirdiff
      vim-dispatch
      vim-fugitive
      vim-gitgutter
      vim-markdown
      vim-nix
      vim-sensible
      vim-startify
      vim-surround
      vim-toml
    ];
    extraConfig = ''
      if filereadable($HOME . "/.vimrc")
        source $HOME/.vimrc
      endif
    '';
  };
}
