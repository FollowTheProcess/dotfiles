{
  flake.modules.homeManager.base = {
    programs.carapace = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
