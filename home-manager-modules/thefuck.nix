{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.programs.thefuck;
  boolToPython = bool: if bool then "True" else "False";
in {
  options.programs.thefuck = with types; {
    enable = mkEnableOption "magnificient app which corrects your previous console command";

    fucks = mkOption {
      type = listOf path;
      default = [];
      description = "List of files to put under .config/thefuck/rules";
      example = literalExample ''
         [
          ./nix_command_not_found.py
         ]
      '';
    };

    debug = mkOption {
      type = bool;
      default = false;
      description = "Whether to enable debug mode";
    };

    enableBashIntegration = mkOption {
      type = bool;
      default = true;
      description = "Enable bash integration";
    };

    enableFishIntegration = mkOption {
      type = bool;
      default = true;
      description = "Enable fish integration";
    };

    enableZshIntegration = mkOption {
      type = bool;
      default = true;
      description = "Enable zsh integration";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.thefuck ];

    home.file = mkMerge ((map (fuck: {
      ".config/thefuck/rules/${baseNameOf fuck}".source = fuck;
    }) cfg.fucks) ++ [ {
      ".config/thefuck/settings.py".source = pkgs.writeText "settings.py" ''
        # rules = [<const: All rules enabled>]
        # exclude_rules = []
        # wait_command = 3
        # require_confirmation = True
        # no_colors = False
        debug = ${boolToPython cfg.debug}
        # priority = {}
        # history_limit = None
        # alter_history = True
        # wait_slow_command = 15
        # slow_commands = ['lein', 'react-native', 'gradle', './gradlew', 'vagrant']
        # repeat = False
        # instant_mode = False
        # num_close_matches = 3
        # env = {'LC_ALL': 'C', 'LANG': 'C', 'GIT_TRACE': '1'}
        # excluded_search_path_prefixes = []
      '';
    }]);

    programs.bash.initExtra = mkIf cfg.enableBashIntegration "eval $(thefuck --alias)";
    programs.zsh.initExtra = mkIf cfg.enableZshIntegration "eval $(thefuck --alias)";
    programs.fish.shellInit = mkIf cfg.enableFishIntegration "eval $(thefuck --alias)";

  };
}
