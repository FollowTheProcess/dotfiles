{ dotfiles, lib, ... }: {
  xdg.enable = true;
  home.preferXdgDirectories = true;

  xdg.configFile = {
    "zed".source = dotfiles + "/.config/zed";
  };

  # TODO: Manage claude and all the settings, agents etc. in nix
  home.file = {
    ".claude/settings.json".source = dotfiles + "/.claude/settings.json";
    "AGENTS.md".source = dotfiles + "/AGENTS.md";
    "CLAUDE.md".source = dotfiles + "/CLAUDE.md";
  };

  home.activation.createDev = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p $HOME/Development
  '';
}
