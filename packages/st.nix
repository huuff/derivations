{ lib, stdenv, fetchurl, makeWrapper, pkg-config, libX11, ncurses
, libXft, patches ? [], extraLibs ? [], flags ? {}}:

with lib;
stdenv.mkDerivation rec {
  pname = "st";
  version = "0.8.4";

  src = fetchurl {
    url = "https://dl.suckless.org/st/${pname}-${version}.tar.gz";
    sha256 = "19j66fhckihbg30ypngvqc9bcva47mp379ch5vinasjdxgn3qbfl";
  };

  inherit patches;

  nativeBuildInputs = [ pkg-config ncurses ];
  buildInputs = [ libX11 libXft makeWrapper ] ++ extraLibs;

  installPhase = let
    flagArgs = map
    (x: let name = builtins.head (attrNames x); in
      ''--add-flags "-${name} '${toString x.${name}}'"'') flags;
    argsString = concatStringsSep " " flagArgs;
  in
  ''
    TERMINFO=$out/share/terminfo make install PREFIX=$out
    ${optionalString (flags != {}) ''
    wrapProgram $out/bin/st \
        ${argsString}
      ''}
  '';

  meta = {
    homepage = "https://st.suckless.org/";
    description = "Simple Terminal for X from Suckless.org Community";
    license = licenses.mit;
    maintainers = with maintainers; [ andsild ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}

