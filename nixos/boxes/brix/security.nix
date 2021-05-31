{ config, pkgs, ... }:
{
  imports = [
  ];
  security.acme.email = "admin@cyplo.dev";
  security.acme.acceptTerms = true;
  security.forcePageTableIsolation = true;
  security.protectKernelImage = true;
  security.apparmor.enable = true;
  security.lockKernelModules = true;

  services.haveged.enable = true;
  services.fail2ban.enable = true;

  environment.systemPackages = with pkgs; [
    knockknock
  ];

  services.openssh = {
    enable = true;
    permitRootLogin = "prohibit-password";
    passwordAuthentication = false;
  };

  users.extraUsers.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJlCoSJ/2BHt0RqQUn2L9DPcCEJBJQWpq+74cpmeaGJL cyryl@foureighty"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDN/2C59i+ucvSa9FLCHlVPJp0zebLOcw0+hnBYwy0cY cyryl@skinnyv"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJwZ4M6lT2yzg8iarCzsLADAuXS4BUkLTt1+mKCECczk nix-builder@brix"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIALNEUIxbENTdhSWzYupGFn/q+AGe0diBOTMyiZAmv7F nix-builder@vultr1"
  ];

  users.users.nix-builder = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJlCoSJ/2BHt0RqQUn2L9DPcCEJBJQWpq+74cpmeaGJL cyryl@foureighty"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDN/2C59i+ucvSa9FLCHlVPJp0zebLOcw0+hnBYwy0cY cyryl@skinnyv"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJwZ4M6lT2yzg8iarCzsLADAuXS4BUkLTt1+mKCECczk nix-builder@brix"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIALNEUIxbENTdhSWzYupGFn/q+AGe0diBOTMyiZAmv7F nix-builder@vultr1"
    ];
  };

  nix.trustedUsers = [ "root" "nix-builder" ];
}
