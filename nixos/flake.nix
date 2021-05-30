{
  description = "NixOS configuration with flakes";
  inputs = {
    futils = {
      type = "github";
      owner = "numtide";
      repo = "flake-utils";
      ref = "master";
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

    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable";
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

  outputs = { self, futils, home-manager, nixpkgs, nur, bisq } @ inputs: {

    nixosConfigurations = {
      foureighty = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          (import ./boxes/foureighty)

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.cyryl = import ./home-manager;
          }

        ];
        specialArgs = { inherit inputs; };
      };
    };
  };
}

