{ inputs, ... }:
let
  flavor = "Catppuccin-Macchiato";
in
{
  programs.fastfetch.enable = true;
  xdg.configFile."fastfetch/config.jsonc".source =
    "${inputs.catppuccin-fastfetch}/themes/${flavor}/config.jsonc";
}
