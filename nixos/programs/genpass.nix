{ pkgs ? import <nixpkgs> {} }:
with pkgs;
rustPlatform.buildRustPackage rec {
  pname = "genpass";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "cyplo";
    repo = pname;
    rev = "v" + version;
    sha256 = "1b22m7g55k5ry0vwyd8pakh8rmfkhk37qy5r74cn3n5pv3fcwini";
  };

  cargoSha256 = "0lpavjm9yq7fcyqj8ihs60ipmz3f724rkyh50j6f62g6fkn8jybi";

  buildInputs = [
    openssl pkgconfig git
  ];

  meta = with stdenv.lib; {
    description = "A simple yet robust commandline random password generator.";
    homepage = "https://github.com/cyplo/genpass";
    license = licenses.agpl3;
    platforms = platforms.all;
  };
}
