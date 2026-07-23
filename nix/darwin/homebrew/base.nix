{
  flake.modules.darwin.base = { config, ... }: {
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
          name = "${config.my.constants.githubUser}/tap";
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
        "${config.my.constants.githubUser}/tap/git-rekt"
        "${config.my.constants.githubUser}/tap/gowc"
        "${config.my.constants.githubUser}/tap/spok"
        "${config.my.constants.githubUser}/tap/tag"
        "${config.my.constants.githubUser}/tap/txtract"
        "obsidian"
        "raycast"
        "slack"
        "spotify"
        "theboredteam/boring-notch/boring-notch"
      ];
    };
  };
}
