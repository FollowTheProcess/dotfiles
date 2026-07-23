{
  flake.modules.homeManager.base = _: {
    programs.carapace = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
