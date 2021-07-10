{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.maven; 
in {

  options.programs.maven = {
    enable = mkEnableOption "Maven package manager for Java";

    options = mkOption {
      type = types.attrs;
      default = {};
      description = "Command line arguments to apply to each Maven invocation";
    };

    settings = mkOption {
      type = types.str;
      default = null;
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.maven ];

    home.file.".mavenrc".source = 
    let
      optionsList = attrsets.mapAttrsToList (name: value: "-D${name}=${value}") cfg.options;
      optionsString = lib.concatStringsSep " " optionsList;
    in
    pkgs.writeShellScript "mavenrc" ''
      MAVEN_OPTS="${optionsString}"
    '';

    home.file.".m2/settings.xml".source = cfg.settings;
  };
}
