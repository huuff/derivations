{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.st; 
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

    exec = mkOption {
      type = with types; nullOr str;
      default = null;
      description = "Program to run after launching";
    };

    flags = mkOption {
      type = with types; listOf attrs;
      default = [];
      description = "Flags to run the executable with";
    };

    scrollback = mkEnableOption "Scrollbar (with mouse wheel)";
  };

  config = let
    colorschemePatch = if (cfg.colorscheme != null)
    then pkgs.stPatches.colorscheme."${cfg.colorscheme}"
    else null;
    applyFlags = cfg.flags
    ++ optional (cfg.fontSize != null) { z = cfg.fontSize;}
    ++ optional (cfg.exec != null) { e = cfg.exec; } 
    ;
  in
  mkIf cfg.enable {
    home.packages = [
      (pkgs.st.override {
        patches = cfg.patches
        ++ flatten (optional cfg.scrollback [ pkgs.stPatches.scrollback.main pkgs.stPatches.scrollback.mouse pkgs.stPatches.scrollback.mouse-altscreen ])
        ++ optional (colorschemePatch != null) colorschemePatch
        ++ optional cfg.blinkingCursor pkgs.stPatches.blinkingCursor
        ++ optional (cfg.fontSize != null) pkgs.stPatches.defaultFontSize
        ;
        flags = applyFlags;
      })
    ];
  };
}
