{
  flake.modules.homeManager.base = {
    programs.granted = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
