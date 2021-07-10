{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.haf.scripts; 
in {
  options.haf.scripts = {
    enable = mkEnableOption "Add ~/scripts to $PATH";
  };

  config = mkIf cfg.enable {

    programs.bash.initExtra = mkIf cfg.enable ''
      PATH="$PATH:/home/$USER/scripts"
    '';
  };
}
