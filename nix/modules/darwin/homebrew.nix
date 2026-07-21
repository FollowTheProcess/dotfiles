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

    masApps = { };
  };
}
