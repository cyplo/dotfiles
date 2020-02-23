{ config, pkgs, ... }:
{
  nix.buildMachines = [
    {
      hostName = "vultr1.local";
      sshUser = "nix-builder";
      sshKey = "/home/cyryl/.ssh/id_ed25519";
      system = "x86_64-linux";
      maxJobs = 2;
      supportedFeatures = [ ];
      mandatoryFeatures = [ ];
    }
    {
      hostName = "brix.local";
      sshUser = "nix-builder";
      sshKey = "/home/cyryl/.ssh/id_ed25519";
      system = "x86_64-linux";
      maxJobs = 1;
      supportedFeatures = [ "kvm" ];
      mandatoryFeatures = [ ];
    }
  ];

  nix.extraOptions = ''
      builders-use-substitutes = true
  '';
  nix.distributedBuilds = true;

}
