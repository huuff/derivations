{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.programs.thefuck;
in {
  options.programs.thefuck = {
    enable = mkEnableOption "Magnificient app which corrects your previous console command";

    fucks = {
      type = with types; listOf path;
      default = [];
      description = "List of files to put under .config/thefuck/rules";
      example = literalExample ''
         [
          ./nix_command_not_found.py
         ]
        '';
    };

    config = mkIf cfg.enable ({
      home.packages = [ pkgs.thefuck ];


    } // listToAttrs (map (fuck: {
        name = "home.file.config/thefuck/rules/${baseNameOf fuck}";
        value = fuck;
    }) cfg.fucks ));
  };
}
