{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.haf.autocutsel; 
  pkg = pkgs.autocutsel;
in {

  options.haf.autocutsel = {
    enable = mkEnableOption "synchronize selections";
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
        ExecStartPre = "${pkg}/bin/autocutsel -fork";
        ExecStart = "${pkg}/bin/autocutsel -fork -selection CLIPBOARD";
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
