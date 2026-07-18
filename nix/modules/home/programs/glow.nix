{ pkgs, ... }:
let
  yamlFormat = pkgs.formats.yaml { };
  # to update: nurl https://github.com/catppuccin/glamour
  catppuccin-glamour = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "glamour";
    rev = "00c97fa3823d272d9d041d5d872ae6335555a776";
    hash = "sha256-SI/COnVFdKltMRqeqLTbR/Rh0xUJcWSqiX/YlR221eo=";
  };
in
{
  # No programs.glow module, so just dump the config
  xdg.configFile."glow/glow.yml".source = yamlFormat.generate "glow.yml" {
    style = "${catppuccin-glamour}/themes/catppuccin-macchiato.json";
  };
}
