{
  flake.modules.homeManager.base = _: {
    programs.granted = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
