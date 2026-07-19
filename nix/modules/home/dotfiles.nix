{
  dotfiles,
  config,
  lib,
  ...
}:
{
  xdg.enable = true;
  home = {
    preferXdgDirectories = true;
    file = {
      # TODO: Manage claude and all the settings, agents etc. in nix
      ".claude/settings.json".source = dotfiles + "/.claude/settings.json";
      "AGENTS.md".source = dotfiles + "/AGENTS.md";
      "CLAUDE.md".source = dotfiles + "/CLAUDE.md";
    };
    activation.createDev = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p ${config.home.homeDirectory}/Development
    '';
  };

  xdg.configFile = {
    "zed".source = dotfiles + "/.config/zed";
  };

}
