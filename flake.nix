{
  description = "NixOS configuration with flakes";
  outputs = { self, flake-utils, home-manager, nixpkgs-nixos-unstable, nixpkgs-stable, nixos-hardware, nur, agenix, neuron } @ inputs:

  let
    mkServer = pkgs: system: hostname:
    pkgs.lib.nixosSystem {
      system = system;
      modules = [
        (./. + "/nixos/boxes/${hostname}")
        agenix.nixosModules.age
      ];
      specialArgs = { inherit inputs; };
    };
    mkWorkstation = pkgs: system: hostname:
    pkgs.lib.nixosSystem {
      system = system;
      modules = [
        (./. + "/nixos/boxes/${hostname}")
        (import ./nixos/email-accounts.nix)

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.cyryl = import ./nixos/home-manager;
        }

      ];
      specialArgs = { inherit inputs; };
    };
  in

  {
    nixosConfigurations = {
      bootstrap = nixpkgs-stable.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          (./. + "/nixos/boxes/bootstrap")
        ];
        specialArgs = { inherit inputs; };
      };
      foureighty = mkWorkstation nixpkgs-stable "x86_64-linux" "foureighty";
      skinnyv = mkWorkstation nixpkgs-stable "x86_64-linux" "skinnyv";
      brix = mkServer nixpkgs-stable "x86_64-linux" "brix";
      vultr1 = mkServer nixpkgs-stable "x86_64-linux" "vultr1";
    };
  };
  inputs = {
    nixpkgs-nixos-unstable = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };

    nixpkgs-stable = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-21.05";
    };

    nixos-hardware = {
      type = "github";
      owner = "NixOS";
      repo = "nixos-hardware";
      ref = "master";
    };

    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
      ref = "release-21.05";
      inputs = {
        nixpkgs.follows = "nixpkgs-stable";
      };
    };

    flake-utils = {
      type = "github";
      owner = "numtide";
      repo = "flake-utils";
      ref = "master";
    };

    nur = {
      type = "github";
      owner = "nix-community";
      repo = "NUR";
      ref = "master";
    };

    agenix = {
      type = "github";
      owner = "ryantm";
      repo = "agenix";
      ref = "master";
    };

    neuron = {
      type = "github";
      owner = "srid";
      repo = "neuron";
      ref = "master";
    };
  };

}

