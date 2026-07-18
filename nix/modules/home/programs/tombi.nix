{ pkgs, ... }:
let
  tomlFormat = pkgs.formats.toml { };
in
{
  # No programs.tombi module, so just dump the config
  xdg.configFile."tombi/config.toml".source = tomlFormat.generate "tombi-config.toml" {
    files.respect-ignore-files = true;
    format.rules = {
      key-value-equals-sign-alignment = false;
      trailing-comment-alignment = true;
    };
  };
}
