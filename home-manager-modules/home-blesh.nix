{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.haf.blesh; 
  blesh = import ./blesh.nix {};
in {

  options.haf.blesh = {
    enable = mkEnableOption "BaSH Line Editor";
  };

  config = mkIf cfg.enable {

    programs.bash.initExtra = mkIf cfg.enable ''
      source ${blesh}/ble.sh
    '';
  };
}
