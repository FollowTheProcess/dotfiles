{ pkgs, ... }:
let
  # to update: nurl https://github.com/catppuccin/eza
  catppuccin-eza = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "eza";
    rev = "70f805f6cc27fa5b91750b75afb4296a0ec7fec9";
    hash = "sha256-Q+C07IReQQBO5xYuFiFbS1wjmO4gdt/wIJWHNwIizSc=";
  };
in
{
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };

  xdg.configFile."eza/theme.yml".source =
    "${catppuccin-eza}/themes/macchiato/catppuccin-macchiato-mauve.yml";
}
