{ inputs, ... }:
{
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };

  xdg.configFile."eza/theme.yml".source =
    "${inputs.catppuccin-eza}/themes/macchiato/catppuccin-macchiato-mauve.yml";
}
