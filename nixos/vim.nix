{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [(
    neovim.override {
      vimAlias = true;
      configure = {
        customRC = ''
          if filereadable($HOME . "/.vimrc")
            source ~/.vimrc
          endif
        '';

        vam.knownPlugins = unstable.vimPlugins;
        vam.pluginDictionaries = [
          { names = [
            "ack-vim"
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
          ];
        }
      ];

    };})
  ];

}
