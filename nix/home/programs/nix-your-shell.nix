{
  flake.modules.homeManager.base = _: {
    programs.nix-your-shell = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
