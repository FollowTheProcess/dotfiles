{
  flake.modules.homeManager.base = {
    programs.mergiraf = {
      enable = true;
      enableGitIntegration = true;
      enableJujutsuIntegration = true;
    };
  };
}
