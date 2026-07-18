{ pkgs, ... }:
let
  yamlFormat = pkgs.formats.yaml { };
in
{
  # No programs.yamlfmt module, so just dump the config
  xdg.configFile."yamlfmt/.yamlfmt".source = yamlFormat.generate "yamlfmt-config.yaml" {
    formatter = {
      type = "basic";
      indent = 2;
      scan_folded_as_literal = true;
      retain_line_breaks_single = true;
      pad_line_comments = 2;
      trim_trailing_whitespace = true;
      eof_newline = true;
    };
    gitignore_excludes = true;
  };
}
