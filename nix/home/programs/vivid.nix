{
  flake.modules.homeManager.base = {
    programs.vivid = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
