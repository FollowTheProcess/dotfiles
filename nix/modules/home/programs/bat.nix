{ inputs, ... }: {
  programs.bat = {
    enable = true;
    config = {
      theme = "Catppuccin Macchiato";
    };
    themes = {
      "Catppuccin Macchiato" = {
        src = inputs.catppuccin-bat;
        file = "themes/Catppuccin Macchiato.tmTheme";
      };
    };
  };
}
