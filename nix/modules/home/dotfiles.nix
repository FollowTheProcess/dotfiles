{
  dotfiles,
  lib,
  ...
}:
{
  xdg.enable = true;

  xdg.configFile = {
    "copier".source = dotfiles + "/.config/copier";
    "glow".source = dotfiles + "/.config/glow";
    "jj".source = dotfiles + "/.config/jj";
    "ls-colors".source = dotfiles + "/.config/ls-colors";
    "paneru".source = dotfiles + "/.config/paneru";
    "tombi".source = dotfiles + "/.config/tombi";
    "yamlfmt".source = dotfiles + "/.config/yamlfmt";
    "zed".source = dotfiles + "/.config/zed";
    "zsh-patina".source = dotfiles + "/.config/zsh-patina";
  };

  home.file = {
    ".claude/settings.json".source = dotfiles + "/.claude/settings.json";
    "AGENTS.md".source = dotfiles + "/AGENTS.md";
    "CLAUDE.md".source = dotfiles + "/CLAUDE.md";
  };

  home.activation.createDev = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p $HOME/Development
  '';
}
