{
  flake.modules.homeManager.base = _: {
    programs.ripgrep = {
      enable = true;
    };
  };
}
