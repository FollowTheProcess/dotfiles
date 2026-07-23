{
  flake.modules.homeManager.base = _: {
    programs.nix-search-tv = {
      enable = true;
      enableTelevisionIntegration = true;
    };
  };
}
