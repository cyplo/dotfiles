{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    (wine.override { wineBuild = "wineWow"; }) winetricks
    steam
  ];
}
