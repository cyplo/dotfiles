{ config, pkgs, ... }:

{
  imports =
    [ 
      /etc/nixos/hardware-configuration.nix
    ];

  environment.systemPackages = with pkgs; [
    wget vim git zsh gnupg curl tmux
  ];

  networking.hostName = "skinnyv";

  users.users.cyryl = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    packages = with pkgs; [
     firefox terminator zsh keepass fontconfig go nodejs rustup gcc gdb binutils xclip pkgconfig veracrypt gitAndTools.diff-so-fancy
    ];
    uid = 1000;
    shell = pkgs.zsh;
  };

  services.syncthing = {
    enable = true;
    user = "cyryl";
    dataDir = "/home/cyryl/.syncthing";
    openDefaultPorts = true;
  };

  services.xserver = {
        enable = true;
        layout = "pl";
	libinput.enable = true;
  
        desktopManager = {
	  gnome3.enable = true;
	  default="gnome3";
          xterm.enable=false;
	};
	displayManager.gdm.enable = true;
  };
  
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  time.timeZone = "Europe/London";
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/disk/by-uuid/8c76bf01-59b3-4c60-b853-e9cb77f3ca14";
      preLVM = true;
      allowDiscards = true;
    }
  ];

  system.stateVersion = "18.09";
}
