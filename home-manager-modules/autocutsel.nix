{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.haf.autocutsel; 
  pkg = pkgs.autocutsel;
in {

  options.haf.autocutsel = {
    enable = mkEnableOption "Automatic systemd unit to synchronize selections";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkg ]; 

    systemd.user.services.autocutsel = {
      Unit = {
        Description = "synchronize clipboard and primary selection";
      };

      Service = {
        Type = "forking";
        Restart = "on-failure";
        ExecStart = "${pkg}/bin/autocutsel -fork";
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
