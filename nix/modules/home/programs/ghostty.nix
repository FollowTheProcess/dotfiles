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
  };
}
