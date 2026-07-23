{
  flake.modules.homeManager.base = _: {
    programs.vivid = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
