{
  flake.modules.homeManager.base = {
    programs.devenv = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
