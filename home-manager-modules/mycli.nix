{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.programs.mycli;
  boolToPython = bool: if bool then "True" else "False"; # Converts a Nix boolean to a python boolean
in {
  options.programs.mycli = with types; {
    enable = mkEnableOption "Command line MySQL interface";

    multiline = mkOption {
      type = bool;
      default = false;
      description = "Execute query only when a semicolon is present, this way pressing enter allows us to write multi line queries. This is the behavior of the original MySQL client.";
    };

    autoVerticalOutput = mkOption {
      type = bool;
      default = false;
      description = "Automatically switch to vertical output mode if the result is wider than the terminal";
    };

    keybindings = mkOption {
      type = enum [ "emacs" "vi" ];
      default = "emacs";
      description = "Keybindings: Possible values: emacs, vi";
    };

    tableFormat = mkOption {
      type = enum [ "ascii" "double" "github" "psql" "plain" "simple" "grid" "fancy_grid" "pipe" "ortgbl" "rs" "mediawiki" "html" "latex" "latex_booktabs" "textile" "moinmoin" "jira" "vertical" "tsv" "csv" ];
      default = "ascii";
      description = "Table format. Recommended: ascii";
    };

    lessChatty = mkOption {
      type = bool;
      default = false;
      description = "Skip intro info on startup and outro info on exit";
    };

    favoriteQueries = mkOption {
      type = attrs;
      default = {};
      description = "Your favorite queries";
      example = literalExample ''
          {
            all = "select * from $1";
          };
        '';
    };

    aliasDSNs = mkOption {
      type = attrs;
      default = {};
      description = "Aliases of DSNs";
      example = literalExample ''
          {
            example_dsn = "mysql://[user[:password]@][host][:port][/dbname]";
          };
        '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.mycli ];

    home.file.".myclirc".source = pkgs.writeText "myclirc" ''
      # Check the defaults at from https://github.com/dbcli/mycli/blob/master/mycli/myclirc
      [main]
      smart_completion = True
      multi_line = ${boolToPython cfg.multiline}
      destructive_warning = True
      log_file = ~/.mycli.log
      log_level = INFO
      timing = True
      table_format = ${cfg.tableFormat}
      syntax_style = default
      key_bindings = ${cfg.keybindings}
      wider_completion_menu = False
      prompt = '\t \u@\h:\d> '
      prompt_continuation = '->'
      less_chatty = ${boolToPython cfg.lessChatty}
      login_path_as_host = False
      auto_vertical_output = ${boolToPython cfg.autoVerticalOutput}
      keyword_casing = auto
      enable_pager = True

      [colors]
      completion-menu.completion.current = 'bg:#ffffff #000000'
      completion-menu.completion = 'bg:#008888 #ffffff'
      completion-menu.meta.completion.current = 'bg:#44aaaa #000000'
      completion-menu.meta.completion = 'bg:#448888 #ffffff'
      completion-menu.multi-column-meta = 'bg:#aaffff #000000'
      scrollbar.arrow = 'bg:#003333'
      scrollbar = 'bg:#00aaaa'
      selected = '#ffffff bg:#6666aa'
      search = '#ffffff bg:#4444aa'
      search.current = '#ffffff bg:#44aa44'
      bottom-toolbar = 'bg:#222222 #aaaaaa'
      bottom-toolbar.off = 'bg:#222222 #888888'
      bottom-toolbar.on = 'bg:#222222 #ffffff'
      search-toolbar = 'noinherit bold'
      search-toolbar.text = 'nobold'
      system-toolbar = 'noinherit bold'
      arg-toolbar = 'noinherit bold'
      arg-toolbar.text = 'nobold'
      bottom-toolbar.transaction.valid = 'bg:#222222 #00ff5f bold'
      bottom-toolbar.transaction.failed = 'bg:#222222 #ff005f bold'
      output.header = "#00ff5f bold"
      output.odd-row = ""
      output.even-row = ""
      output.null = "#808080"

      [favorite_queries]
      ${concatStringsSep "\n" (mapAttrsToList (name: value: "${name} = '''${value}'''") cfg.favoriteQueries)}

      [alias_dsn]
      ${concatStringsSep "\n" (mapAttrsToList (name: value: "${name} = ${value}") cfg.aliasDSNs)}
    '';
  };
}
