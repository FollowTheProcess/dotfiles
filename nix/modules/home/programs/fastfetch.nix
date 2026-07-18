{ pkgs, ... }:
let
  # to update: nurl https://github.com/Nukecraft5419/fastfetch
  catppuccin-fastfetch = pkgs.fetchFromGitHub {
    owner = "Nukecraft5419";
    repo = "fastfetch";
    rev = "0e014dd34461c741a12778ce68e29cd184ff3be6";
    hash = "sha256-XS9sS4k1VGh5NHuRBxrrme+Bi42nomA7sp+EhrVlBmY=";
  };
  flavor = "Catppuccin-Macchiato"; # matches the starship palette
in
{
  programs.fastfetch.enable = true;
  xdg.configFile."fastfetch/config.jsonc".source =
    "${catppuccin-fastfetch}/themes/${flavor}/config.jsonc";
}
