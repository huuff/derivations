{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.haf.st; 
  st = pkgs.callPackage ./st.nix { };
  stPatches = import ./st-patches.nix;
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

    blinkingCursor = mkEnableOption "blinking cursor";

    colorscheme = mkOption {
      type = with types; nullOr (enum ["dracula" "gruvbox-dark" "gruvbox-light" "gruvbox-material" ]);
      default = null;
      description = "Colorscheme to apply";
    };
  };

  config = let
    colorschemePatch = if (cfg.colorscheme != null)
    then stPatches."${cfg.colorscheme}"
    else null;
  in
  mkIf cfg.enable {
    home.packages = [
      (st.override {
        fontSize = cfg.fontSize;
        applyPatches = cfg.patches
        ++ optional (colorschemePatch != null) colorschemePatch
        ++ optional cfg.blinkingCursor stPatches.blinkingCursor
        ;
      })
    ];
  };
}
