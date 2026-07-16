{
  dotfiles,
  lib,
  ...
}:
{
  xdg.enable = true;

  xdg.configFile = {
    "copier".source = dotfiles + "/.config/copier";
    "direnv".source = dotfiles + "/.config/direnv";
    "gh".source = dotfiles + "/.config/gh";
    "ghostty".source = dotfiles + "/.config/ghostty";
    "git".source = dotfiles + "/.config/git";
    "glow".source = dotfiles + "/.config/glow";
    "jj".source = dotfiles + "/.config/jj";
    "k9s".source = dotfiles + "/.config/k9s";
    "ls-colors".source = dotfiles + "/.config/ls-colors";
    "nushell".source = dotfiles + "/.config/nushell";
    "paneru".source = dotfiles + "/.config/paneru";
    "ruff".source = dotfiles + "/.config/ruff";
    "television".source = dotfiles + "/.config/television";
    "tombi".source = dotfiles + "/.config/tombi";
    "uv".source = dotfiles + "/.config/uv";
    "starship.toml".source = dotfiles + "/.config/starship.toml";
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
