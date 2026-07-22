{ pkgs, inputs, ... }:
{
  # No programs.glow module, so just dump the config
  xdg.configFile."glow/glow.yml".source = (pkgs.formats.yaml { }).generate "glow.yml" {
    style = "${inputs.catppuccin-glamour}/themes/catppuccin-macchiato.json";
  };
}
