{ config, pkgs, ... }:
{
  nix.buildMachines = [
    {
      hostName = "brix.local";
      sshUser = "nix-builder";
      sshKey = "/home/cyryl/.ssh/id_ed25519";
      system = "x86_64-linux";
      maxJobs = 2;
      speedFactor = 1;
      supportedFeatures = [ "kvm" ];
      mandatoryFeatures = [ ];
    }
    {
      hostName = "vultr1.local";
      sshUser = "nix-builder";
      sshKey = "/home/cyryl/.ssh/id_ed25519";
      system = "x86_64-linux";
      maxJobs = 4;
      speedFactor = 4;
      supportedFeatures = [ ];
      mandatoryFeatures = [ ];
    }
  ];

  nix.extraOptions = ''
      builders-use-substitutes = true
  '';
  nix.distributedBuilds = true;

}
