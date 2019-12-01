{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    wget git gnupg curl tmux python36Packages.glances htop atop pciutils powertop ripgrep-all fd dnsutils
    ( pass.withExtensions (ext: [ ext.pass-otp ext.pass-import ext.pass-genphrase ext.pass-audit ext.pass-update ]))
    cabal-install stack hsetroot lm_sensors
    wirelesstools ranger apvlv
    fontconfig rustup gcc gdb
    binutils veracrypt gitAndTools.diff-so-fancy
    restic ghc jq awscli
    hugo mercurial terraform
    unzip aria
    mono calcurse file python37Packages.binwalk-full
    nixops
  ];
}
