My common dotfiles for Linux, Mac and Cygwin

Contains my e.g. my vim, terminal and font configs.

Fonts:
  [cyryl@dagrey ~]$ cd .local/share/  
  [cyryl@dagrey share]$ rm -fr fonts 
  [cyryl@dagrey share]$ ln -s /home/cyryl/dev/dotfiles/.local/share/fonts .
  [cyryl@dagrey fontconfig]$ cd
  [cyryl@dagrey ~]$ cd .config/fontconfig/       
  [cyryl@dagrey fontconfig]$ rm -fr conf.d 
  [cyryl@dagrey fontconfig]$ ln -s /home/cyryl/dev/dotfiles/.config/fontconfig/conf.d .
  [cyryl@dagrey fontconfig]$ cd
  [cyryl@dagrey ~]$ fc-cache


