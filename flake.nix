{
  description = "NixOS configuration with flakes";
  outputs = { self, flake-utils, home-manager, nixpkgs-nixos-unstable, nixpkgs-stable, nur, bisq, agenix } @ inputs: {
    nixosConfigurations = {
      foureighty = nixpkgs-stable.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          (import ./nixos/boxes/foureighty)

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.cyryl = import ./nixos/home-manager;
          }

        ];
        specialArgs = { inherit inputs; };
      };
      skinnyv = nixpkgs-stable.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          (import ./nixos/boxes/skinnyv)

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.cyryl = import ./nixos/home-manager;
          }

        ];
        specialArgs = { inherit inputs; };
      };
      brix = nixpkgs-stable.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          (import ./nixos/boxes/brix)
          agenix.nixosModules.age
        ];
        specialArgs = { inherit inputs; };
      };
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

    bisq = {
      type = "github";
      owner = "emmanuelrosa";
      repo = "nixpkgs";
      ref = "3a681b0daaed9841cbd3ea2ebd51f9cca4c836f2";
    };

    agenix = {
      type = "github";
      owner = "ryantm";
      repo = "agenix";
      ref = "master";
    };
  };

}

