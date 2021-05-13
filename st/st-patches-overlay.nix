self: super: {
  stPatches = {
    dracula = builtins.fetchurl {
      url = "https://st.suckless.org/patches/dracula/st-dracula-0.8.2.diff";
      sha256 = "0zpvhjg8bzagwn19ggcdwirhwc17j23y5avcn71p74ysbwvy1f2y";
    };
    blinkingCursor = builtins.fetchurl {
      url = "https://st.suckless.org/patches/blinking_cursor/st-blinking_cursor-20200531-a2a7044.diff";
      sha256 = "0bda4x0xms5slim35jc0zm0d7rmvz6q1g8zm8hgxil6lyvkqfm7h";
    };
    defaultFontSize = builtins.fetchurl {
      url = "https://st.suckless.org/patches/defaultfontsize/st-defaultfontsize-20210225-4ef0cbd.diff";
      sha256 = "0jji1p096zpkyxg7cmxhj4mgvwg582xgl1xw7lfkirxdxf1lp70m";
    };
  };
}

