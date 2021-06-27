{ config, pkgs, ... }:
let
  authorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE5Ejx5CAPUfHVXi4GL4WmnZaG8eiiOmsW/a0o1bs1GF cyryl@foureighty"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDN/2C59i+ucvSa9FLCHlVPJp0zebLOcw0+hnBYwy0cY cyryl@skinnyv"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJwZ4M6lT2yzg8iarCzsLADAuXS4BUkLTt1+mKCECczk nix-builder@brix"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIALNEUIxbENTdhSWzYupGFn/q+AGe0diBOTMyiZAmv7F nix-builder@vultr1"
  ];
in
  {
    imports = [
      ./security.nix
    ];
    security.acme.email = "admin@cyplo.dev";
    security.acme.acceptTerms = true;

    services.fail2ban.enable = true;

    services.openssh = {
      enable = true;
      permitRootLogin = "prohibit-password";
      passwordAuthentication = false;
    };

    users.extraUsers.root.openssh.authorizedKeys.keys = authorizedKeys;
    users.users.nix-builder = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = authorizedKeys;
    };

    nix.trustedUsers = [ "root" "nix-builder" ];
  }
