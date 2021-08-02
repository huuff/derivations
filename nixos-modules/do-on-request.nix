{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.services.do-on-request;
in
  {
    options.services.do-on-request = {
      enable = mkEnableOption "Run something when receiving a request on some port";

      port = mkOption {
        type = types.int;
        default = 12222;
        description = "Port on which to listen";
      };

      script = mkOption {
        type = types.str;
        default = null;
        description = "Script to run when a request is received";
      };

      preScript = mkOption {
        type = with types; nullOr str;
        default = null;
        description = "Script to run before starting the unit";
      };

      workingDirectory = mkOption {
        type = with types; nullOr str;
        default = "/";
        description = "Path on which to run the script";
      };

      user = mkOption {
        type = types.str;
        default = null;
        description = "User which will run the service";
      };
    };

    config = mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.script != null;
          message = "services.do-on-request.script must be set!";
        }
        {
          assertion = cfg.user != null;
          message = "services,do-on-request.user must be set!";
        }
      ];

      systemd.services.do-on-request = {
        description = "Run a script when a request is received on port ${toString cfg.port}";
        
        preStart = optionalString (cfg.preScript != null) "\n ${cfg.preScript}";

        serviceConfig = {
          User = cfg.user;
          Restart = "always";
          WorkingDirectory = "${cfg.workingDirectory}";
        };

        script = ''
          #!${pkgs.stdenv.shell}
          set -x
          while true;
          do {
            ${cfg.script}
          } | ${pkgs.netcat}/bin/nc -l ${toString cfg.port};
          done
          '';

          wantedBy = [ "default.target" ];
          wants = [ "network.target" ];

          unitConfig = {
            After = [ "network.target" ];
          };
      };
    };

  }
