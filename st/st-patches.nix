{
  dracula = builtins.fetchurl {
    url = "https://st.suckless.org/patches/dracula/st-dracula-0.8.2.diff";
    sha256 = "0zpvhjg8bzagwn19ggcdwirhwc17j23y5avcn71p74ysbwvy1f2y";
  };

  gruvbox-dark = builtins.fetchurl {
    url = "https://st.suckless.org/patches/gruvbox/st-gruvbox-dark-0.8.2.diff";
    sha256 = "0bhvw1jam9s0km5hwbnicb27sgwzj04msmwc8gvpf2islpnxbcsf";
  };

  gruvbox-light = builtins.fetchurl {
    url = "https://st.suckless.org/patches/gruvbox/st-gruvbox-light-0.8.2.diff";
    sha256 = "0szjs6cfs09v0mca5bhgisbjpapgmsphk6qczbd3sg6j4faaiw2k";
  };

  gruvbox-material = builtins.fetchurl {
    url = "https://st.suckless.org/patches/gruvbox-material/st-gruvbox-material-0.8.2.diff";
    sha256 = "13wjrjkzzsmxw2lfb1cirkrk2dyg6zawflvwb11l62zlsg05x3r9";
  };

  blinkingCursor = builtins.fetchurl {
    url = "https://st.suckless.org/patches/blinking_cursor/st-blinking_cursor-20200531-a2a7044.diff";
    sha256 = "0bda4x0xms5slim35jc0zm0d7rmvz6q1g8zm8hgxil6lyvkqfm7h";
  };

  defaultFontSize = builtins.fetchurl {
    url = "https://st.suckless.org/patches/defaultfontsize/st-defaultfontsize-20210225-4ef0cbd.diff";
    sha256 = "0jji1p096zpkyxg7cmxhj4mgvwg582xgl1xw7lfkirxdxf1lp70m";
  };
}

