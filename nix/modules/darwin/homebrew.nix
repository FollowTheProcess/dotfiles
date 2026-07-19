_: {
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    taps =
      map
        (name: {
          inherit name;
          trusted = true;
        })
        [
          "charmbracelet/tap"
          "followtheprocess/tap"
          "nao1215/tap"
          "taiki-e/tap"
          "theboredteam/boring-notch"
        ];

    brews = [
      "charmbracelet/tap/freeze"
      "nao1215/tap/gup"
    ];

    casks = [
      "theboredteam/boring-notch/boring-notch"
      "brainfm"
      "claude-code@latest"
      "docker-desktop"
      "followtheprocess/tap/git-rekt"
      "followtheprocess/tap/gowc"
      "obsidian"
      "raycast"
      "slack"
      "followtheprocess/tap/spok"
      "spotify"
      "followtheprocess/tap/tag"
      "followtheprocess/tap/txtract"
      "zed"
    ];

    masApps = { };
  };
}
