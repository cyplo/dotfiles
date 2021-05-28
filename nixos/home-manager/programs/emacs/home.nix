{ config, pkgs, ... }:
{
  home.file.".emacs".text = ''
    (require 'package)

    ;; optional. makes unpure packages archives unavailable
    (setq package-archives nil)

    (setq package-enable-at-startup nil)
    (package-initialize)

    (require 'xterm-color)
    (progn (add-hook 'comint-preoutput-filter-functions 'xterm-color-filter)
       (setq comint-output-filter-functions (remove 'ansi-color-process-output comint-output-filter-functions)))


    (set-terminal-parameter nil 'background-mode 'dark)
    (xterm-mouse-mode 1)

    (require 'evil)
    (evil-mode 1)
  '';
  programs.emacs = {
    enable = true;
    package = (import ./emacs.nix { inherit pkgs; });
  };

}
