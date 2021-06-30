{ pkgs, lib, config, ...}:
with lib;
let
  cfg = config.services.auto-rsync;
in
  {
    options.services.auto-rsync = {

      startPath = mkOption {
        type = types.str;
        default = null;
        description = "Path of the input";
      };

      endPath = mkOption {
        type = types.str;
        default = null;
        description = "Path of the output";
      };

      preScript = mkOption {
        type = types.str;
        default = "";
        description = "Script to execute before starting";
      };

      createStartPath = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to create the start path before starting";
      };

      createEndPath = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to create the end path before starting";
      };
    };

    config = {
      assertions = [
        {
          assertion = cfg.startPath != null;
          message = "cfg.startPath must be set!";
        }
        {
          assertion = cfg.endPath != null;
          message = "cfg.endPath must be set!";
        }
      ];

      systemd.services.auto-rsync = {
        description = "Automatically rsync ${toString cfg.startPath} to ${toString cfg.endPath}";

        preStart = optionalString (cfg.createStartPath) "mkdir -p ${cfg.startPath} || true"
        + optionalString (cfg.createEndPath) "\n mkdir -p ${cfg.endPath} || true"
        + optionalString (cfg.preScript != null) "\n ${cfg.preScript}";

        serviceConfig = {
          Restart = "on-failure";
        };

        wantedBy = [ "default.target" ];

        script = ''
          #!${pkgs.stdenv.shell}
          set -euo pipefail
          ${pkgs.fd}/bin/fd . ${cfg.startPath} | ${pkgs.entr}/bin/entr -n -s "${pkgs.rsync}/bin/rsync -rtvu ${cfg.startPath}/* ${cfg.endPath}"
        '';

      };
    };
  }
