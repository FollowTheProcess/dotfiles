{
  flake.modules.homeManager.base = {
    programs.atuin = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        dialect = "uk";
      };
    };
  };
}
