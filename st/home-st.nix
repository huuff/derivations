{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.haf.st; 
  st = pkgs.callPackage ./st.nix {};
in {

  options.haf.st = {
    enable = mkEnableOption "Simple Terminal from suckless";

    patches = mkOption {
      type = with types; listOf package;
      default = [ ];
      description = "List of patches to apply";
    };

    fontSize = mkOption {
      type = with types; int;
      default = 10;
      description = "Default font size to use";
    };
  };

  config = mkIf cfg.enable {

    home.packages = [
      (st.override {
        patches = cfg.patches; 
        fontSize = cfg.fontSize;
      })
    ];
  };
}
