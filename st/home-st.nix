{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.haf.st; 
in {

  options.haf.st = {
    enable = mkEnableOption "Simple Terminal from suckless";

    patches = mkOption {
      type = with types; listOf package;
      default = [ ];
      description = "List of patches to apply";
    };
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      (st.override { patches = cfg.patches; })
    ];
  };
}
