{ lib, stdenv, fetchurl, makeWrapper, pkg-config, libX11, ncurses
, libXft, applyPatches ? [], extraLibs ? [], fontSize ? 10}:

with lib;
let
  stPatches = import ./st-patches.nix;
in
stdenv.mkDerivation rec {
  pname = "st";
  version = "0.8.4";

  src = fetchurl {
    url = "https://dl.suckless.org/st/${pname}-${version}.tar.gz";
    sha256 = "19j66fhckihbg30ypngvqc9bcva47mp379ch5vinasjdxgn3qbfl";
  };

  patches = [ stPatches.defaultFontSize ] ++ applyPatches;

  nativeBuildInputs = [ pkg-config ncurses ];
  buildInputs = [ libX11 libXft makeWrapper ] ++ extraLibs;

  installPhase = ''
    TERMINFO=$out/share/terminfo make install PREFIX=$out
    wrapProgram $out/bin/st \
      --add-flags "-z ${toString fontSize}"
  '';

  meta = {
    homepage = "https://st.suckless.org/";
    description = "Simple Terminal for X from Suckless.org Community";
    license = licenses.mit;
    maintainers = with maintainers; [ andsild ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}

