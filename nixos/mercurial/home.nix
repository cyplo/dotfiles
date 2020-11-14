{ config, pkgs, ... }:
{
  programs.mercurial = {
    enable = true;
    userName = "Cyryl Płotnicki";
    userEmail = "cyplo@cyplo.dev";
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
