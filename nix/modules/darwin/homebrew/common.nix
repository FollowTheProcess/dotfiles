_: {
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    # TODO: When I have flakes for my personal projects I can drop my tap
    taps = [
      {
        name = "followtheprocess/tap";
        trusted = true;
      }
      {
        name = "theboredteam/boring-notch";
        trusted = true;
      }
    ];
    casks = [
      "1password"
      "brainfm"
      "docker-desktop"
      "followtheprocess/tap/git-rekt"
      "followtheprocess/tap/gowc"
      "followtheprocess/tap/spok"
      "followtheprocess/tap/tag"
      "followtheprocess/tap/txtract"
      "obsidian"
      "raycast"
      "slack"
      "spotify"
      "theboredteam/boring-notch/boring-notch"
    ];
  };
}
