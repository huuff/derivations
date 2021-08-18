{ config, lib, pkgs, ... }:
# TODO: Have maven config as attr set and convert to XML
with lib;

let
  cfg = config.programs.maven; 
in {

  options.programs.maven = {
    enable = mkEnableOption "maven config management";

    options = mkOption {
      type = types.attrs;
      default = {};
      description = "Command line arguments to apply to each Maven invocation";
    };

    settings = mkOption {
      type = types.str;
      default = null;
      description = "Text to put under .m2/settings.xml";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.maven ];

    home.file.".mavenrc".source = 
    let
      optionsList = attrsets.mapAttrsToList (name: value: "-D${name}=${value}") cfg.options;
      optionsString = lib.concatStringsSep " " optionsList;
    in
    pkgs.writeText "mavenrc" ''
      MAVEN_OPTS="${optionsString}"
    '';

    home.file.".m2/settings.xml".source = pkgs.writeText "settings.xml" cfg.settings;
  };
}
