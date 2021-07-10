{ pkgs, lib, config, ... }: 
with lib;
let
  cfg = config.services.neuron;
in
  {

    options.services.neuron = {
      enable = mkEnableOption "Automatically generate (or generate and serve) Neuron";

      path = mkOption {
        type = types.str;
        default = null;
        description = "Path of the zettelkasten root";
      };

      serve = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to also serve after generating";
      };

      port = mkOption {
        type = types.int;
        default = 80;
        description  = "Port from which to serve neuron";
      };
    };

    config = mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.path != null;
          message = "services.neuron.path must be set!";
        }
      ];

      systemd.services.neuron = {
        description = "Neuron instance";

        serviceConfig = {
          Restart = "on-failure";
          WorkingDirectory = cfg.path;
          ExecStart = if cfg.serve
          then "${pkgs.neuron-notes}/bin/neuron rib -ws localhost:${cfg.port}"
          else "${pkgs.neuron-notes}/bin/neuron rib -w";
        };

        wantedBy = [ "default.target" ];

      };

    };
  }

