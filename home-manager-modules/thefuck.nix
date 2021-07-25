{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.programs.thefuck;
in {
  options.programs.thefuck = with types; {
    enable = mkEnableOption "Magnificient app which corrects your previous console command";

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

    home.file = mkMerge (map (fuck: {
      ".config/thefuck/rules/${baseNameOf fuck}".source = fuck;
    }) cfg.fucks);

    programs.bash.initExtra = mkIf cfg.enableBashIntegration "eval $(thefuck --alias)";
    programs.zsh.initExtra = mkIf cfg.enableZshIntegration "eval $(thefuck --alias)";
    programs.fish.shellInit = mkIf cfg.enableFishIntegration "eval $(thefuck --alias)";
  };
}
