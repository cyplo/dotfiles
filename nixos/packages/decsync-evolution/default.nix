with import <nixpkgs> {};

stdenv.mkDerivation rec {
    name = "evolution-decsync";
    version = "1.0.1";
    src = fetchFromGitHub {
        owner = "39aldo39";
        repo = "Evolution-DecSync";
        rev = "v1.0.1";
        sha256 = "0cq5cvc9ywcbwrhj5nm9azjmjwc8hxfbw3r7bjqkjd0bwfnxk3g6";
        fetchSubmodules = true;
    };

    buildInputs = [ libgee json-glib gnome3.evolution-data-server gnome3.evolution gtk3 webkitgtk glib libsecret libsoup];
    nativeBuildInputs = [ meson ninja vala pkg-config ];
    configurePhase = "meson build --prefix=$out";
    buildPhase = "ninja -C build";
    installPhase = "ninja -C build install";
}