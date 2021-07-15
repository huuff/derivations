{ pkgs, lib, ... }:
with lib;
let
  cfg = config.programs.mycli;
in {
  options.programs.mycli = {
    enable = mkEnableOption;

    favoriteQueries = mkOption {
      type = types.attrs;
      default = {};
      description = "Your favorite queries";
      example = literalExample ''
          {
            all = "select * from $1";
          };
        '';
    };

    aliasDSNs = mkOption {
      type = types.attrs;
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

    home.file.".myclirc".source = ''
  # Check the defaults at from https://github.com/dbcli/mycli/blob/master/mycli/myclirc
  [main]
  smart_completion = True
  multi_line = False
  destructive_warning = True
  log_file = ~/.mycli.log
  log_level = INFO
  timing = True
  table_format = ascii
  syntax_style = default
  key_bindings = emacs
  wider_completion_menu = False
  prompt = '\t \u@\h:\d> '
  prompt_continuation = '->'
  less_chatty = False
  login_path_as_host = False
  auto_vertical_output = False
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
    '';
  };
}
