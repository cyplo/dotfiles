{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vim tmux atop btrfs-progs compsize
  ];
}
