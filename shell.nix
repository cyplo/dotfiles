let
  nixpkgs = import <nixpkgs> {};
in
  with nixpkgs;
  stdenv.mkDerivation {
    name = "legacy_shell";
    buildInputs = [
      (pkgs.writeShellScriptBin "nix-experimental" ''
        exec ${pkgs.nixUnstable}/bin/nix --experimental-features "nix-command flakes" "$@"
      '')
      git
    ];
    shellHook = ''
    '';
  }
