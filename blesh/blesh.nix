{ pkgs ? import <nixpkgs> {}}:

with pkgs;
stdenv.mkDerivation rec {
  pname = "blesh";
  version = "0.4.0-devel2";

  src = pkgs.fetchurl {
    url = "https://github.com/akinomyoga/ble.sh/releases/download/v0.4.0-devel2/ble-0.4.0-devel2.tar.xz";
    sha256 = "0ssamnqsprxqn96fpq0krf5178lrsvny9acrpnpq5913hk8hv88m";
  };

  buildInputs = [ gnumake coreutils ];

  outputs = [ "out" ];
  
  installPhase = ''
    mkdir -p "$out"
    cp -r ble.sh keymap lib contrib "$out"
  '';
}
