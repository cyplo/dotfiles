{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    (import ./programs/genpass.nix {})
    wget git gnupg curl tmux htop atop pciutils powertop ripgrep-all fd dnsutils du-dust
    ( pass.withExtensions (ext: [ ext.pass-otp ext.pass-import ext.pass-genphrase ext.pass-audit ext.pass-update ]))
    hsetroot lm_sensors
    wirelesstools ranger apvlv
    fontconfig
    binutils veracrypt gitAndTools.diff-so-fancy
    restic jq awscli
    hugo mercurial terraform
    unzip aria
    calcurse file python37Packages.binwalk-full
    nixops imagemagick
    docker-compose rustup
    knockknock
  ];
}
