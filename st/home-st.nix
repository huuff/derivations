{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.st; 
  st = pkgs.callPackage ./st.nix { };
  stPatches = import ./st-patches.nix;
in {

  options.programs.st = {
    enable = mkEnableOption "Simple Terminal from suckless";

    patches = mkOption {
      type = with types; listOf package;
      default = [ ];
      description = "List of patches to apply";
    };

    fontSize = mkOption {
      type = with types; nullOr int;
      default = 10;
      description = "Default font size to use";
    };

    blinkingCursor = mkEnableOption "Blinking cursor";

    colorscheme = mkOption {
      type = with types; nullOr (enum ["dracula" "gruvbox-dark" "gruvbox-light" "gruvbox-material" ]);
      default = null;
      description = "Colorscheme to apply";
    };

    flags = mkOption {
      type = with types; attrs;
      default = {};
      description = "Flags to run the executable with";
    };

    scrollback = mkEnableOption "Scrollbar (with mouse wheel)";
  };

  config = let
    colorschemePatch = if (cfg.colorscheme != null)
    then stPatches.colorscheme."${cfg.colorscheme}"
    else null;
    applyFlags = optionalAttrs (cfg.fontSize != null) { z = cfg.fontSize;}
    // cfg.flags 
    ;
  in
  mkIf cfg.enable {
    home.packages = [
      (st.override {
        patches = cfg.patches
        ++ flatten (optional cfg.scrollback [ stPatches.scrollback.main stPatches.scrollback.mouse stPatches.scrollback.mouse-altscreen ])
        ++ optional (colorschemePatch != null) colorschemePatch
        ++ optional cfg.blinkingCursor stPatches.blinkingCursor
        ++ optional (cfg.fontSize != null) stPatches.defaultFontSize
        ;
        flags = applyFlags;
      })
    ];
  };
}
