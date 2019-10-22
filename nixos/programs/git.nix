{ config, pkgs, lib, ... }:
{
  programs.git = {
    enable = true;
    userName = "Cyryl Płotnicki";
    userEmail = "cyplo@cyplo.net";
    extraConfig = {
      core = { pager = "cat"; };
      pager = {
        diff = "diff-so-fancy | less --tabs=1,5 -RFX";
        show = "diff-so-fancy | less --tabs=1,5 -RFX";
      };
    };
    aliases =
      {
        tree = "log --show-signature --color --decorate --date=short --all --graph -n 3";
        newbranch = "!git checkout master && git fetch -p && git reset --hard origin/master && git checkout -b $2";
        head = "log HEAD -n1";
      };
    };
  }
