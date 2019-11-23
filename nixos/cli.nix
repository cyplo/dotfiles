{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    ( pass.withExtensions (ext: [ ext.pass-otp ext.pass-import ext.pass-genphrase ext.pass-audit ext.pass-update ]))
    cabal-install stack hsetroot lm_sensors
    wirelesstools ranger apvlv
    fontconfig rustup gcc gdb
    binutils veracrypt gitAndTools.diff-so-fancy
    restic ghc jq awscli
    hugo mercurial terraform
    unzip aria
    mono calcurse file python37Packages.binwalk-full
  ];
}
