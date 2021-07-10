{ tmuxPlugins}:
    final: prev: {
      tmuxPlugins = {
      better-mouse-mode = prev.pkgs.tmuxPlugins.mkTmuxPlugin {
        pluginName = "better-mouse-mode";
        version = "rev-aa59077c635ab21b251bd8cb4dc24c415e64a58e";
        src = prev.pkgs.fetchFromGitHub {
          owner = "NHDaly";
          repo = "tmux-better-mouse-mode";
          rev = "aa59077c635ab21b251bd8cb4dc24c415e64a58e";
          sha256 = "06346ih3hzwszhkj25g4xv5av7292s6sdbrdpx39p0n3kgf5mwww";
        };
      };
    } // prev.pkgs.tmuxPlugins;
    }
