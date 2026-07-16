{ pkgs, ... }: {
  programs.bat = {
    enable = true;
    config = {
      theme = "Catppuccin Macchiato";
    };
    themes = {
      "Catppuccin Macchiato" = {
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "bat";
          rev = "6810349b28055dce54076712fc05fc68da4b8ec0";
          sha256 = "sha256-a3Rtj0Ba4NwlpDZaMmk3gd6/2QO2b06oanBwaFonSTk=";
        };
        file = "themes/Catppuccin Macchiato.tmTheme";
      };
    };
  };
}
