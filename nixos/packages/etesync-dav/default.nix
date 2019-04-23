with import <nixpkgs> {};

stdenv.mkDerivation rec {
    name = "etesync-dav";
    version = "0.5.0";
    src = fetchurl {
        url = "https://github.com/etesync/etesync-dav/releases/download/v0.5.0/linux-etesync-dav";
        sha256 = "0mf7yir1whqbvdfz4551zknanv8wxxk7a21bfgx3lb9kchl6qy9c";
    };

    unpackCmd = "mkdir unpacked;cp $curSrc ./unpacked/etesync-dav";
    installPhase = ''
      mkdir -p $out/bin/
      cp -vr ./* $out/bin/
      chmod a+x -R $out/bin/
    '';
    buildInputs = [ autoPatchelfHook libzip ];
}
