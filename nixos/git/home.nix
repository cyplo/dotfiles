{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Cyryl Płotnicki";
    userEmail = "cyplo@cyplo.net";
    delta = {
      enable = true;
      options = {
        line-numbers = true;
        syntax-theme = "Solarized (dark)";
      };
    };
    extraConfig = {
      colour.ui = true;
      credential = { helper ="cache"; };
      diff.algorithm = "histogram";
      diff.renameLimit = 2048;
      diff.renames = "copy";
      help.autocorrect = 1;
      merge.renamelimit = 8192;
      mergetool.keepBackup = false;
      pull.ff = "only";
      push.default = "simple";
    };
    aliases =
      {
        tree = "log --show-signature --color --decorate --date=short --all --graph -n 3";
        newbranch = "!git checkout master && git fetch -p && git reset --hard origin/master && git checkout -b $2";
        head = "log HEAD -n1";
        vacuum = "!git fetch -p && git branch -vv | awk '/: gone]/{print $1}' | xargs -r git branch -D && git gc --aggressive --auto";
      };
    };
  }
