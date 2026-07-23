{
  flake.modules.homeManager.base = _: {
    programs.devenv = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
