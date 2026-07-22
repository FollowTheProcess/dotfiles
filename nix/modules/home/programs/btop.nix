{ inputs, ... }:
{
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "catppuccin_macchiato";
      theme_background = false;
    };
    themes = {
      catppuccin_macchiato = builtins.readFile "${inputs.catppuccin-btop}/themes/catppuccin_macchiato.theme";
    };
  };
}
