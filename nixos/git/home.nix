{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Cyryl Płotnicki";
    userEmail = "cyplo@cyplo.net";
    extraConfig = {
      credential = { helper ="cache"; };
      core = { pager = "cat"; };
      pager = {
        diff = "${pkgs.gitAndTools.diff-so-fancy}/bin/diff-so-fancy | less --tabs=1,5 -RFX";
        show = "${pkgs.gitAndTools.diff-so-fancy}/bin/diff-so-fancy | less --tabs=1,5 -RFX";
      };
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
