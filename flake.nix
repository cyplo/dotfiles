{
  description = "NixOS configuration with flakes";
  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };

    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
      ref = "master";
      inputs = {
        nixpkgs.follows = "nixpkgs";
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
  };

  outputs = { self, flake-utils, home-manager, nixpkgs, nur, bisq } @ inputs: {

    nixosConfigurations = {
      foureighty = nixpkgs.lib.nixosSystem {
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
    };
  };
}

