{ config, ... }: {
  programs.ghostty = {
    enable = true;
    # The actual package is ghostty-bin
    # see https://ghostty.org/docs/install/binary#nix-(macos-binary)
    #
    # This lets me manage ghostty's config with nix but not
    # build it from source with the rest of nix stuff until
    # it can support it
    package = null;
    enableZshIntegration = true;
    settings = {
      background-blur = true;
      background-opacity = 0.9;
      clipboard-read = "allow";
      clipboard-write = "allow";
      cursor-style = "bar";
      font-family = "GeistMono Nerd Font";
      font-feature = [
        "calt"
        "dlig"
        "liga"
      ];
      font-size = 12.5;
      font-style = "Regular";
      theme = "catppuccin-macchiato";
      macos-titlebar-style = "tabs";
      quit-after-last-window-closed = true;
      shell-integration-features = true;
      window-colorspace = "display-p3";
      window-height = 50;
      window-inherit-working-directory = true;
      window-padding-x = 6;
      window-width = 130;
      working-directory = "${config.home.homeDirectory}/Development";
    };
    themes = {
      catppuccin-macchiato = {
        # Annoyingly can't do the fetchFromGithub trick here
        # but this is https://github.com/catppuccin/ghostty
        palette = [
          "0=#494d64"
          "1=#ed8796"
          "2=#a6da95"
          "3=#eed49f"
          "4=#8aadf4"
          "5=#f5bde6"
          "6=#8bd5ca"
          "7=#a5adcb"
          "8=#5b6078"
          "9=#ed8796"
          "10=#a6da95"
          "11=#eed49f"
          "12=#8aadf4"
          "13=#f5bde6"
          "14=#8bd5ca"
          "15=#b8c0e0"
        ];
        background = "24273a";
        foreground = "cad3f5";
        cursor-color = "f4dbd6";
        cursor-text = "181926";
        selection-background = "3a3e53";
        selection-foreground = "cad3f5";
        split-divider-color = "363a4f";
      };
    };
  };
}
