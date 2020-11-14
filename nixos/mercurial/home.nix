{ config, pkgs, ... }:
{
  programs.mercurial = {
    enable = true;
    userName = "Cyryl Płotnicki";
    userEmail = "cyplo@cyplo.net";
    extraConfig = ''
      [extensions]
      hgext.convert=
      [ui]
      paginate = never
    '';
    aliases =
      {
      };
    };
  }
