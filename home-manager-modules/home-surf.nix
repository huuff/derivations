{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.surf; 
in {

  options.programs.surf = {
    enable = mkEnableOption "surf simple web browser from suckless";

    patches = mkOption {
      type = with types; listOf package;
      default = [ ];
      description = "List of patches to apply";
    };
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      (surf.override { patches = cfg.patches; })
    ];
  };
}
