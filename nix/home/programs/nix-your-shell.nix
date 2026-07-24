{
  flake.modules.homeManager.base = {
    programs.nix-your-shell = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
