final: prev: {
  surfPatches = {
    homepage = builtins.fetchurl {
      url = "https://surf.suckless.org/patches/homepage/surf-2.0-homepage.diff";
      sha256 = "0dhgk48qh1i6my2n81wxkzqjlkrvj1376dsizsmx1lawldwm1045";
    };
  };
}

