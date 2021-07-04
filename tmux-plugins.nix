{ tmuxPlugins}:
    final: prev: with prev.pkgs; {
      tmuxPlugins = {
      better-mouse-mode = tmuxPlugins.mkTmuxPlugin {
        pluginName = "better-mouse-mode";
        version = "rev aa59077c635ab21b251bd8cb4dc24c415e64a58e";
        src = fetchFromGitHub {
          owner = "NHDaly";
          repo = "tmux-better-mouse-mode";
          rev = "aa59077c635ab21b251bd8cb4dc24c415e64a58e";
          sha256 = "06346ih3hzwszhkj25g4xv5av7292s6sdbrdpx39p0n3kgf5mwww";
        };
      };
    };
    }
